#' Create a Cytoscape visual style for PANDA network
#'
#'This function is able to create a Cytoscape visual style for any PANDA network output.
#' @param style.name Character string indicating the style name. Defaults to "PandaStyle"
#'
#' @return a visual style in Cytoscape Control Panel under "Style" button.
#' @import RCy3
#' @export

create.panda.style <- function(style.name="PandaStyle"){
  
  # node properties
  nodeShape <- mapVisualProperty('node shape','group','d',c("TF","Gene"),c("ELLIPSE","RECTANGLE"))
  nodeColor <- mapVisualProperty('node fill color', 'group','d', c("TF","Gene"), c('#FD7622', '#499df3'))
  nodeBorderColor <- mapVisualProperty("Node Border Paint", 'group', 'd', c("TF","Gene"), c('#FD7622', '#499df3'))
  nodeLabel <- mapVisualProperty("node label","id",'p')

  # edge properties
  edgeLineType <- mapVisualProperty('edge line type','interaction','d',c("1","0"), c("SOLID","LONG_DASH"))
  edgeTargetArrowShape <- mapVisualProperty("edge target arrow shape",'interaction','d',c(0,1),c("DELTA","DELTA"))
  edgeTargetArrowUnSelectedPaint <- mapVisualProperty("Edge Target Arrow Unselected Paint","weight_transformed",'c',c(0,10000),c('#d3d3d3', '#000000'))
  # edge width and edge color shade both represent the edge weight.
  edgeWidth <- mapVisualProperty("edge width", "weight_transformed",'c', c(0,10000), c(0.5,7))
  edgeStrokeUnselectedPaint <- mapVisualProperty('Edge Stroke Unselected Paint',"weight_transformed",'c',c(0,10000), c('#d3d3d3', '#000000'))
  
  # default setting
  defaults <- list(NODE_SIZE=50,
                 EDGE_TRANSPARENCY=255,
                 NODE_LABEL_POSITION="center")
  # create visual style working for PANDA network
  createVisualStyle(style.name,defaults,list(nodeShape, nodeColor, nodeBorderColor,nodeLabel,
                                           edgeLineType, edgeTargetArrowShape, edgeTargetArrowUnSelectedPaint,
                                           edgeWidth, edgeStrokeUnselectedPaint))

}

