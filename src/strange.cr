require "./strange/version"
require "./strange/strange"

require "./strange/transport/file_transport"
require "./strange/formatter/json_formatter"

logger = Strange.new(level: :env)
logger.transports.clear
logger.transports << Strange::FileTransport.new(
  File.expand_path("~/Desktop/test.log", __DIR__),
  formatter: Strange::JSONFormatter.new(indent: true)
)

logger.emerg("Hello world")
logger.alert("Hello world")
logger.crit("Hello world")
logger.error("Hello world")
logger.warning("Hello world")
logger.notice("Hello world")
logger.info("Hello world")
logger.debug("Hello world")
