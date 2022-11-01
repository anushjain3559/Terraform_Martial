#Defining the variables
region                        = "us-west-2"
bucket_name                   = "gilead-kdh-tst-us-west-2-raw"
object_key                    = "raw//utilities//temp_dataload//"
appflowname                   = "KDH-RAW"
nametype                      = "FULL-KKCAN" #FULL-KKUS or EVENT-KKCAN or EVENT-KKUS
objectsname                   = "CASE_HIST"  #Object Name can be CONTACT or ACCOUNT OR Case or CASE_HIST
source_connector_type         = "Salesforce"
source_connector_profile_name = "KK-CAN" # KK-US or KK-CAN or KK-EU
source_connector_object       = "Case__c_hd" # Account or Case or Contact or Case__c_hd
destination_connector_type    = "S3"
tasktype                      = "Map_all"
trigger_type                  = "OnDemand"
