library(AzureAuth)
library(shiny)
library(shinyjs)

tenant <- "afe83590-2911-4d8e-89d9-45ed016b5852"
app <- "aed8882d-0e4e-4d67-83f9-8a8e1ab961fa"

# the Azure resource permissions needed
# if your app doesn't use any Azure resources (you only want to do authentication),
# set the resource to "openid" only
resource <- c("openid", "offline_access")

# set this to the site URL of your app once it is deployed
# this must also be the redirect for your registered app in Azure Active Directory
redirect <- "http://localhost:3838/"

port <- httr::parse_url(redirect)$port
options(shiny.port=if(is.null(port)) 80 else as.numeric(port))

# replace this with your app's regular UI
ui <- fluidPage(
    useShinyjs(),
    verbatimTextOutput("token")
)

ui_func <- function(req)
{
    opts <- parseQueryString(req$QUERY_STRING)
    if(is.null(opts$code))
    {
        auth_uri <- build_authorization_uri(resource, tenant, app, redirect_uri=redirect, version=2)
        redir_js <- sprintf("location.replace(\"%s\");", auth_uri)
        tags$script(HTML(redir_js))
    }
    else ui
}

# code for cleaning url after authentication
clean_url_js <- sprintf(
    "
    $(document).ready(function(event) {
      const nextURL = '%s';
      const nextTitle = 'My new page title';
      const nextState = { additionalInformation: 'Updated the URL with JS' };
      // This will create a new entry in the browser's history, without reloading
      window.history.pushState(nextState, nextTitle, nextURL);
    });
    ", redirect
)

server <- function(input, output, session)
{
    shinyjs::runjs(clean_url_js)

    opts <- parseQueryString(isolate(session$clientData$url_search))
    if(is.null(opts$code))
        return()

    # this assumes your app has a 'public client/native' redirect:
    # if it is a 'web' redirect, include the client secret as the password argument
    token <- get_azure_token(resource, tenant, app, auth_type="authorization_code",
                             authorize_args=list(redirect_uri=redirect), version=2,
                             use_cache=FALSE, auth_code=opts$code, 
                             password="ikd8Q~YiLhm2l65D4luZXwZWRayTmWdBdY-rsaLf")

    output$token <- renderPrint(token)
}

shinyApp(ui_func, server)