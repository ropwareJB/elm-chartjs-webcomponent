module Chartjs.Internal.Encode exposing
    ( encodeData
    , encodeOptions
    )

import Chartjs.Common as Common
import Chartjs.Data
import Chartjs.DataSets.Bar
import Chartjs.DataSets.DoughnutAndPie
import Chartjs.DataSets.Line
import Chartjs.DataSets.Polar
import Chartjs.Internal.Util as Encode
import Chartjs.Options
import Chartjs.Options.Animations
import Chartjs.Options.Elements
import Chartjs.Options.Font
import Chartjs.Options.Layout
import Chartjs.Options.Legend
import Chartjs.Options.Scale
import Chartjs.Options.Title
import Chartjs.Options.Tooltips
import Dict
import Json.Encode as Encode


encodeBarChartDataSet : Chartjs.DataSets.Bar.DataSet -> Encode.Value
encodeBarChartDataSet barChartDataSet =
    Encode.beginObject
        |> Encode.stringField "label" barChartDataSet.label
        |> Encode.stringField "type" "bar"
        |> Encode.listField "data" Encode.float barChartDataSet.data
        |> Encode.maybeBoolField "hidden" barChartDataSet.hidden
        |> Encode.maybeIntField "order" barChartDataSet.order
        |> Encode.maybeStringField "stack" barChartDataSet.stack
        |> Encode.maybeCustomField "indexAxis" encodeIndexAxis barChartDataSet.indexAxis
        |> Encode.maybeStringField "xAxisID" barChartDataSet.xAxisID
        |> Encode.maybeStringField "yAxisID" barChartDataSet.yAxisID
        |> Encode.maybeCustomField "backgroundColor" (encodePointProperty Encode.encodeColor) barChartDataSet.backgroundColor
        |> Encode.maybeFloatField "barPercentage" barChartDataSet.barPercentage
        |> Encode.maybeIntField "barThickness" barChartDataSet.barThickness
        |> Encode.maybeCustomField "borderColor" (encodePointProperty Encode.encodeColor) barChartDataSet.borderColor
        |> Encode.maybeCustomField "borderRadius" (encodePointProperty Encode.int) barChartDataSet.borderRadius
        |> Encode.maybeStringField "borderSkipped" barChartDataSet.borderSkipped
        |> Encode.maybeCustomField "borderWidth" (encodePointProperty Encode.float) barChartDataSet.borderWidth
        |> Encode.maybeFloatField "categoryPercentage" barChartDataSet.categoryPercentage
        |> Encode.maybeCustomField "hoverBackgroundColor" (encodePointProperty Encode.encodeColor) barChartDataSet.hoverBackgroundColor
        |> Encode.maybeCustomField "hoverBorderColor" (encodePointProperty Encode.encodeColor) barChartDataSet.hoverBorderColor
        |> Encode.maybeCustomField "hoverBorderWidth" (encodePointProperty Encode.float) barChartDataSet.hoverBorderWidth
        |> Encode.maybeIntField "maxBarThickness" barChartDataSet.maxBarThickness
        |> Encode.maybeIntField "minBarLength" barChartDataSet.minBarLength
        |> Encode.toValue


encodeDoughnutAndPieDataSet : Chartjs.DataSets.DoughnutAndPie.DataSet -> Encode.Value
encodeDoughnutAndPieDataSet pieChartDataSet =
    Encode.beginObject
        |> Encode.stringField "label" pieChartDataSet.label
        |> Encode.stringField "type" "pie"
        |> Encode.listField "data" Encode.float pieChartDataSet.data
        |> Encode.maybeBoolField "hidden" pieChartDataSet.hidden
        |> Encode.maybeIntField "order" pieChartDataSet.order
        |> Encode.maybeCustomField "backgroundColor" (encodePointProperty Encode.encodeColor) pieChartDataSet.backgroundColor
        |> Encode.maybeStringField "borderAlign" pieChartDataSet.borderAlign
        |> Encode.maybeCustomField "borderColor" (encodePointProperty Encode.encodeColor) pieChartDataSet.borderColor
        |> Encode.maybeCustomField "borderWidth" (encodePointProperty Encode.float) pieChartDataSet.borderWidth
        |> Encode.maybeIntField "circumference" pieChartDataSet.circumference
        |> Encode.maybeIntField "cutout" pieChartDataSet.cutout
        |> Encode.maybeCustomField "hoverBackgroundColor" (encodePointProperty Encode.encodeColor) pieChartDataSet.hoverBackgroundColor
        |> Encode.maybeCustomField "hoverBorderColor" (encodePointProperty Encode.encodeColor) pieChartDataSet.hoverBorderColor
        |> Encode.maybeCustomField "hoverBorderWidth" (encodePointProperty Encode.float) pieChartDataSet.hoverBorderWidth
        |> Encode.maybeCustomField "offset" (encodePointProperty Encode.int) pieChartDataSet.offset
        |> Encode.maybeIntField "rotation" pieChartDataSet.rotation
        |> Encode.maybeFloatField "weight" pieChartDataSet.weight
        |> Encode.toValue


encodeLineChartDataSet : Chartjs.DataSets.Line.DataSet -> Encode.Value
encodeLineChartDataSet lineChartDataSet =
    Encode.beginObject
        |> Encode.stringField "label" lineChartDataSet.label
        |> Encode.customField "type" encodeLineDatasetType lineChartDataSet.type_
        |> Encode.customField "data" encodeLineData lineChartDataSet.data
        |> Encode.maybeStringField "xAxisID" lineChartDataSet.xAxisID
        |> Encode.maybeStringField "yAxisID" lineChartDataSet.yAxisID
        |> Encode.maybeCustomField "backgroundColor" (encodePointProperty Encode.encodeColor) lineChartDataSet.backgroundColor
        |> Encode.maybeCustomField "borderColor" (encodePointProperty Encode.encodeColor) lineChartDataSet.borderColor
        |> Encode.maybeCustomField "borderWidth" (encodePointProperty Encode.float) lineChartDataSet.borderWidth
        |> Encode.maybeCustomField "borderDash" (encodePointProperty Encode.float) lineChartDataSet.borderDash
        |> Encode.maybeFloatField "borderDashOffset" lineChartDataSet.borderDashOffset
        |> Encode.maybeStringField "borderCapStyle" lineChartDataSet.borderCapStyle
        |> Encode.maybeStringField "borderJoinStyle" lineChartDataSet.borderJoinStyle
        |> Encode.maybeStringField "cubicInterpolationMode" lineChartDataSet.cubicInterpolationMode
        |> Encode.maybeCustomField "fill" encodeFillMode lineChartDataSet.fill
        |> Encode.maybeFloatField "tension" lineChartDataSet.lineTension
        |> Encode.maybeCustomField "pointBackgroundColor" (encodePointProperty Encode.encodeColor) lineChartDataSet.pointBackgroundColor
        |> Encode.maybeCustomField "pointBorderWidth" (encodePointProperty Encode.float) lineChartDataSet.pointBorderWidth
        |> Encode.maybeCustomField "pointRadius" (encodePointProperty Encode.float) lineChartDataSet.pointRadius
        |> Encode.maybeCustomField "pointStyle" (encodePointProperty encodePointStyle) lineChartDataSet.pointStyle
        |> Encode.maybeCustomField "pointRotation" (encodePointProperty Encode.float) lineChartDataSet.pointRotation
        |> Encode.maybeCustomField "pointHitRadius" (encodePointProperty Encode.float) lineChartDataSet.pointHitRadius
        |> Encode.maybeCustomField "pointHoverBackgroundColor" (encodePointProperty Encode.encodeColor) lineChartDataSet.pointHoverBackgroundColor
        |> Encode.maybeCustomField "pointHoverBorderColor" (encodePointProperty Encode.encodeColor) lineChartDataSet.pointHoverBorderColor
        |> Encode.maybeCustomField "pointHoverBorderWidth" (encodePointProperty Encode.float) lineChartDataSet.pointHoverBorderWidth
        |> Encode.maybeCustomField "pointHoverRadius" (encodePointProperty Encode.float) lineChartDataSet.pointHoverRadius
        |> Encode.maybeBoolField "showLine" lineChartDataSet.showLine
        |> Encode.maybeBoolField "spanGaps" lineChartDataSet.spanGaps
        |> Encode.maybeCustomField "stepped" encodeSteppedLine lineChartDataSet.steppedLine
        |> Encode.toValue


encodeLineDatasetType : Chartjs.DataSets.Line.LineDataSetType -> Encode.Value
encodeLineDatasetType type_ =
    case type_ of
        Chartjs.DataSets.Line.Line ->
            Encode.string "line"

        Chartjs.DataSets.Line.Radar ->
            Encode.string "radar"


encodeLineData : Chartjs.DataSets.Line.DataPoints -> Encode.Value
encodeLineData data =
    case data of
        Chartjs.DataSets.Line.Numbers numbers ->
            Encode.list Encode.float numbers

        Chartjs.DataSets.Line.Points points ->
            Encode.list
                (\( x, y ) ->
                    Encode.beginObject
                        |> Encode.floatField "x" x
                        |> Encode.floatField "y" y
                        |> Encode.toValue
                )
                points


encodePolarDataSet : Chartjs.DataSets.Polar.DataSet -> Encode.Value
encodePolarDataSet polarDataSet =
    Encode.beginObject
        |> Encode.stringField "label" polarDataSet.label
        |> Encode.listField "data" Encode.float polarDataSet.data
        |> Encode.maybeCustomField "backgroundColor" (encodePointProperty Encode.encodeColor) polarDataSet.backgroundColor
        |> Encode.maybeStringField "borderAlign" polarDataSet.borderAlign
        |> Encode.maybeCustomField "borderColor" (encodePointProperty Encode.encodeColor) polarDataSet.borderColor
        |> Encode.maybeCustomField "borderWidth" (encodePointProperty Encode.float) polarDataSet.borderWidth
        |> Encode.maybeCustomField "hoverBackgroundColor" (encodePointProperty Encode.encodeColor) polarDataSet.hoverBackgroundColor
        |> Encode.maybeCustomField "hoverBorderColor" (encodePointProperty Encode.encodeColor) polarDataSet.hoverBorderColor
        |> Encode.maybeCustomField "hoverBorderWidth" (encodePointProperty Encode.float) polarDataSet.hoverBorderWidth
        |> Encode.toValue


encodeSteppedLine : Chartjs.DataSets.Line.SteppedLine -> Encode.Value
encodeSteppedLine steppedLine =
    case steppedLine of
        Chartjs.DataSets.Line.NoInterpolation ->
            Encode.bool False

        Chartjs.DataSets.Line.BeforeInterpolation ->
            Encode.string "before"

        Chartjs.DataSets.Line.AfterInterpolation ->
            Encode.string "after"


encodeFillMode : Chartjs.DataSets.Line.FillMode -> Encode.Value
encodeFillMode fillMode =
    case fillMode of
        Chartjs.DataSets.Line.Absolute i ->
            Encode.int i

        Chartjs.DataSets.Line.Relative i ->
            Encode.int i

        -- BUGBUG, possibly needs to be String, '-1', '-2', '+1', ...
        Chartjs.DataSets.Line.Boundary Chartjs.DataSets.Line.Start ->
            Encode.string "start"

        Chartjs.DataSets.Line.Boundary Chartjs.DataSets.Line.End ->
            Encode.string "end"

        Chartjs.DataSets.Line.Boundary Chartjs.DataSets.Line.Origin ->
            Encode.string "origin"

        Chartjs.DataSets.Line.Disabled ->
            Encode.bool False


encodePosition : Common.Position -> Encode.Value
encodePosition position =
    (case position of
        Common.Top ->
            "top"

        Common.Left ->
            "left"

        Common.Bottom ->
            "bottom"

        Common.Right ->
            "right"
    )
        |> Encode.string


encodeAlign : Common.Align -> Encode.Value
encodeAlign align =
    (case align of
        Common.Start ->
            "start"

        Common.End ->
            "end"

        Common.Center ->
            "center"
    )
        |> Encode.string


encodeIndexAxis : Common.IndexAxis -> Encode.Value
encodeIndexAxis axis =
    (case axis of
        Common.XAxis ->
            "x"

        Common.YAxis ->
            "y"
    )
        |> Encode.string


encodePointProperty : (a -> Encode.Value) -> Common.PointProperty a -> Encode.Value
encodePointProperty valueEncoder value =
    case value of
        Common.All innerValue ->
            valueEncoder innerValue

        Common.PerPoint valueList ->
            Encode.list valueEncoder valueList


encodePointStyle : Common.PointStyle -> Encode.Value
encodePointStyle pointStyle =
    (case pointStyle of
        Common.Circle ->
            "circle"

        Common.Cross ->
            "cross"

        Common.CrossRot ->
            "crossRot"

        Common.Dash ->
            "dash"

        Common.Line ->
            "line"

        Common.Rect ->
            "rect"

        Common.RectRounded ->
            "rectRounded"

        Common.RectRot ->
            "rectRot"

        Common.Star ->
            "star"

        Common.Triangle ->
            "triangle"

        Common.Image str ->
            "<img src=\"" ++ str ++ "\"/>"
    )
        |> Encode.string


encodeLineCap : Common.LineCap -> Encode.Value
encodeLineCap lineCap =
    (case lineCap of
        Common.LineCapButt ->
            "butt"

        Common.LineCapRound ->
            "round"

        Common.LineCapSquare ->
            "square"
    )
        |> Encode.string


encodeLineJoin : Common.LineJoin -> Encode.Value
encodeLineJoin lineJoin =
    (case lineJoin of
        Common.LineJoinBevel ->
            "bevel"

        Common.LineJoinRound ->
            "round"

        Common.LineJoinMiter ->
            "miter"
    )
        |> Encode.string


encodeData : Chartjs.Data.Data -> Encode.Value
encodeData data =
    Encode.beginObject
        |> Encode.maybeListField "labels" Encode.string data.labels
        |> Encode.listField "datasets" encodeDataset data.datasets
        |> Encode.toValue


encodeDataset : Chartjs.Data.DataSet -> Encode.Value
encodeDataset dataSet =
    case dataSet of
        Chartjs.Data.BarData barChartDataSet ->
            encodeBarChartDataSet barChartDataSet

        Chartjs.Data.LineData lineChartDataSet ->
            encodeLineChartDataSet lineChartDataSet

        Chartjs.Data.PieData doughnutAndPieDataSet ->
            encodeDoughnutAndPieDataSet doughnutAndPieDataSet

        Chartjs.Data.PolarData polarDataSet ->
            encodePolarDataSet polarDataSet


encodeOptions : Chartjs.Options.Options -> Encode.Value
encodeOptions options =
    Encode.beginObject
        |> Encode.customField "plugins" encodeOptionsPlugins options
        |> Encode.maybeCustomField "animations" encodeAnimations options.animations
        |> Encode.maybeCustomField "layout" encodeLayout options.layout
        |> Encode.maybeCustomField "elements" encodeElements options.elements
        |> Encode.maybeCustomField "scales" encodeScales options.scales
        |> Encode.maybeBoolField "maintainAspectRatio" options.maintainAspectRatio
        |> Encode.maybeBoolField "responsive" options.responsive
        |> Encode.maybeIntField "cutoutPercentage" options.cutoutPercentage
        |> Encode.maybeFloatField "rotation" options.rotation
        |> Encode.maybeFloatField "circumfernece" options.circumference
        |> Encode.toValue


encodeOptionsPlugins : Chartjs.Options.Options -> Encode.Value
encodeOptionsPlugins options =
    Encode.beginObject
        |> Encode.maybeCustomField "legend" encodeLegend options.legend
        |> Encode.maybeCustomField "title" encodeTitle options.title
        |> Encode.maybeCustomField "tooltip" encodeTooltips options.tooltips
        |> Encode.toValue


encodeAnimations : Chartjs.Options.Animations.Animations -> Encode.Value
encodeAnimations animations =
    Encode.beginObject
        |> Encode.maybeIntField "duration" animations.duration
        |> Encode.maybeCustomField "easing" encodeEasing animations.easing
        |> Encode.maybeBoolField "animateRotate" animations.animateRotate
        |> Encode.maybeBoolField "animateScale" animations.animateScale
        |> Encode.toValue


encodeEasing : Chartjs.Options.Animations.Easing -> Encode.Value
encodeEasing easing =
    (case easing of
        Chartjs.Options.Animations.EaseLinear ->
            "linear "

        Chartjs.Options.Animations.EaseInQuad ->
            "easeInQuad "

        Chartjs.Options.Animations.EaseOutQuad ->
            "easeOutQuad "

        Chartjs.Options.Animations.EaseInOutQuad ->
            "easeInOutQuad "

        Chartjs.Options.Animations.EaseInCubic ->
            "easeInCubic "

        Chartjs.Options.Animations.EaseOutCubic ->
            "easeOutCubic "

        Chartjs.Options.Animations.EaseInOutCubic ->
            "easeInOutCubic "

        Chartjs.Options.Animations.EaseInQuart ->
            "easeInQuart "

        Chartjs.Options.Animations.EaseOutQuart ->
            "easeOutQuart "

        Chartjs.Options.Animations.EaseInOutQuart ->
            "easeInOutQuart "

        Chartjs.Options.Animations.EaseInQuint ->
            "easeInQuint "

        Chartjs.Options.Animations.EaseOutQuint ->
            "easeOutQuint "

        Chartjs.Options.Animations.EaseInOutQuint ->
            "easeInOutQuint "

        Chartjs.Options.Animations.EaseInSine ->
            "easeInSine "

        Chartjs.Options.Animations.EaseOutSine ->
            "easeOutSine "

        Chartjs.Options.Animations.EaseInOutSine ->
            "easeInOutSine "

        Chartjs.Options.Animations.EaseInExpo ->
            "easeInExpo "

        Chartjs.Options.Animations.EaseOutExpo ->
            "easeOutExpo "

        Chartjs.Options.Animations.EaseInOutExpo ->
            "easeInOutExpo "

        Chartjs.Options.Animations.EaseInCirc ->
            "easeInCirc "

        Chartjs.Options.Animations.EaseOutCirc ->
            "easeOutCirc "

        Chartjs.Options.Animations.EaseInOutCirc ->
            "easeInOutCirc "

        Chartjs.Options.Animations.EaseInElastic ->
            "easeInElastic "

        Chartjs.Options.Animations.EaseOutElastic ->
            "easeOutElastic "

        Chartjs.Options.Animations.EaseInOutElastic ->
            "easeInOutElastic "

        Chartjs.Options.Animations.EaseInBack ->
            "easeInBack "

        Chartjs.Options.Animations.EaseOutBack ->
            "easeOutBack "

        Chartjs.Options.Animations.EaseInOutBack ->
            "easeInOutBack "

        Chartjs.Options.Animations.EaseInBounce ->
            "easeInBounce "

        Chartjs.Options.Animations.EaseOutBounce ->
            "easeOutBounce "

        Chartjs.Options.Animations.EaseInOutBounce ->
            "easeInOutBounce "
    )
        |> Encode.string


encodeFont : Chartjs.Options.Font.FontSpec -> Encode.Value
encodeFont font =
    Encode.beginObject
        |> Encode.maybeStringField "family" font.family
        |> Encode.maybeFloatField "lineHeight" font.lineHeight
        |> Encode.maybeIntField "size" font.size
        |> Encode.maybeStringField "style" font.style
        |> Encode.maybeStringField "weight" font.weight
        |> Encode.toValue


encodeElements : Chartjs.Options.Elements.Elements -> Encode.Value
encodeElements elements =
    Encode.beginObject
        |> Encode.maybeCustomField "point" encodePoint elements.point
        |> Encode.maybeCustomField "line" encodeLine elements.line
        |> Encode.maybeCustomField "rectangle" encodeRectangle elements.rectangle
        |> Encode.maybeCustomField "arc" encodeArc elements.arc
        |> Encode.toValue


encodePoint : Chartjs.Options.Elements.Point -> Encode.Value
encodePoint point =
    Encode.beginObject
        |> Encode.maybeIntField "radius" point.radius
        |> Encode.maybeCustomField "pointStyle" encodePointStyle point.pointStyle
        |> Encode.maybeIntField "rotation" point.rotation
        |> Encode.maybeColorField "backgroundColor" point.backgroundColor
        |> Encode.maybeIntField "borderWidth" point.borderWidth
        |> Encode.maybeColorField "borderColor" point.borderColor
        |> Encode.maybeIntField "hitRadius" point.hitRadius
        |> Encode.maybeIntField "hoverRadius" point.hoverRadius
        |> Encode.maybeIntField "hoverBorderWidth" point.hoverBorderWidth
        |> Encode.toValue


encodeLine : Chartjs.Options.Elements.Line -> Encode.Value
encodeLine line =
    Encode.beginObject
        |> Encode.maybeFloatField "tension" line.tension
        |> Encode.maybeColorField "backgroundColor" line.backgroundColor
        |> Encode.maybeIntField "borderWidth" line.borderWidth
        |> Encode.maybeColorField "borderColor" line.borderColor
        |> Encode.maybeCustomField "borderCapStyle" encodeLineCap line.borderCapStyle
        |> Encode.maybeListField "borderDash" Encode.int line.borderDash
        |> Encode.maybeIntField "borderDashOffset" line.borderDashOffset
        |> Encode.maybeCustomField "borderJoinStyle" encodeLineJoin line.borderJoinStyle
        |> Encode.maybeBoolField "capBezierPoints" line.capBezierPoints
        |> Encode.maybeCustomField "fill" encodeLineFill line.fill
        |> Encode.maybeBoolField "stepped" line.stepped
        |> Encode.toValue


encodeLineFill : Chartjs.Options.Elements.LineFill -> Encode.Value
encodeLineFill lineFill =
    case lineFill of
        Chartjs.Options.Elements.Zero ->
            Encode.string "zero"

        Chartjs.Options.Elements.Top ->
            Encode.string "top"

        Chartjs.Options.Elements.Bottom ->
            Encode.string "bottom"

        Chartjs.Options.Elements.NoFill ->
            Encode.bool False


encodeRectangle : Chartjs.Options.Elements.Rectangle -> Encode.Value
encodeRectangle rectangle =
    Encode.beginObject
        |> Encode.maybeColorField "backgroundColor" rectangle.backgroundColor
        |> Encode.maybeIntField "borderWidth" rectangle.borderWidth
        |> Encode.maybeColorField "borderColor" rectangle.borderColor
        |> Encode.maybeCustomField "borderSkipped" encodePosition rectangle.borderSkipped
        |> Encode.toValue


encodeArc : Chartjs.Options.Elements.Arc -> Encode.Value
encodeArc arc =
    Encode.beginObject
        |> Encode.maybeColorField "backgroundColor" arc.backgroundColor
        |> Encode.maybeColorField "borderColor" arc.borderColor
        |> Encode.maybeIntField "borderWidth" arc.borderWidth
        |> Encode.toValue


encodeLayout : Chartjs.Options.Layout.Layout -> Encode.Value
encodeLayout layout =
    case layout of
        Chartjs.Options.Layout.Uniform i ->
            Encode.int i

        Chartjs.Options.Layout.Specific { left, right, top, bottom } ->
            Encode.beginObject
                |> Encode.intField "left" left
                |> Encode.intField "right" right
                |> Encode.intField "top" top
                |> Encode.intField "bottom" bottom
                |> Encode.toValue


encodeLegend : Chartjs.Options.Legend.Legend -> Encode.Value
encodeLegend legend =
    Encode.beginObject
        |> Encode.maybeBoolField "display" legend.display
        |> Encode.maybeCustomField "position" encodePosition legend.position
        |> Encode.maybeBoolField "fullWidth" legend.fullWidth
        |> Encode.maybeBoolField "reverse" legend.reverse
        |> Encode.maybeCustomField "labels" encodeLegendLabels legend.labels
        |> Encode.maybeCustomField "title" encodeLegendTitle legend.title
        |> Encode.toValue


encodeLegendLabels : Chartjs.Options.Legend.Labels -> Encode.Value
encodeLegendLabels labels =
    Encode.beginObject
        |> Encode.maybeIntField "boxWidth" labels.boxWidth
        |> Encode.maybeIntField "boxHeight" labels.boxWidth
        |> Encode.maybeColorField "color" labels.color
        |> Encode.maybeCustomField "font" encodeFont labels.font
        |> Encode.maybeIntField "padding" labels.padding
        |> Encode.maybeCustomField "pointStyle" encodePointStyle labels.pointStyle
        |> Encode.maybeCustomField "usePointStyle" (\_ -> Encode.bool True) labels.pointStyle
        |> Encode.toValue


encodeLegendTitle : Chartjs.Options.Legend.Title -> Encode.Value
encodeLegendTitle title =
    Encode.beginObject
        |> Encode.stringField "display" "true"
        |> Encode.stringField "text" title.text
        |> Encode.maybeColorField "color" title.color
        |> Encode.maybeCustomField "font" encodeFont title.font
        |> Encode.maybeIntField "padding" title.padding
        |> Encode.toValue


encodeScales : List Chartjs.Options.Scale.Scale -> Encode.Value
encodeScales scales =
    let
        scalesById =
            scales
                |> List.map (\x -> ( x.id, x ))
                |> Dict.fromList
    in
    Encode.dict identity encodeScale scalesById


encodeScale : Chartjs.Options.Scale.Scale -> Encode.Value
encodeScale scale =
    Encode.beginObject
        |> Encode.customField "type" encodeScaleType scale.type_
        |> Encode.maybeCustomField "axis" encodeIndexAxis scale.axis
        |> Encode.maybeCustomField "position" encodePosition scale.position
        |> Encode.maybeBoolField "reverse" scale.reverse
        |> Encode.maybeFloatField "min" scale.min
        |> Encode.maybeFloatField "max" scale.max
        |> Encode.maybeFloatField "suggestedMin" scale.suggestedMin
        |> Encode.maybeFloatField "suggestedMax" scale.suggestedMax
        |> Encode.maybeCustomField "grid" encodeGrid scale.grid
        |> Encode.maybeCustomField "title" encodeScaleTitle scale.title
        |> Encode.maybeCustomField "ticks" encodeTicks scale.ticks
        |> Encode.toValue


encodeScaleType : Chartjs.Options.Scale.ScaleType -> Encode.Value
encodeScaleType scaleType =
    (case scaleType of
        Chartjs.Options.Scale.Linear ->
            "linear"

        Chartjs.Options.Scale.Logarithmic ->
            "logarithmic"

        Chartjs.Options.Scale.Categorical ->
            "category"

        Chartjs.Options.Scale.Time ->
            "time"

        Chartjs.Options.Scale.RadialLinear ->
            "radialLinear"
    )
        |> Encode.string


encodeGrid : Chartjs.Options.Scale.ScaleGrid -> Encode.Value
encodeGrid grid =
    Encode.beginObject
        |> Encode.maybeColorField "borderColor" grid.borderColor
        |> Encode.maybeIntField "borderWidth" grid.borderWidth
        |> Encode.maybeColorField "color" grid.gridColor
        |> Encode.maybeBoolField "drawBorder" grid.drawBorder
        |> Encode.maybeBoolField "drawOnChartArea" grid.drawOnChartArea
        |> Encode.maybeBoolField "drawTicks" grid.drawTicks
        |> Encode.maybeColorField "tickColor" grid.tickColor
        |> Encode.maybeIntField "tickLength" grid.tickLength
        |> Encode.maybeIntField "tickWidth" grid.tickWidth
        |> Encode.toValue


encodeScaleTitle : Chartjs.Options.Scale.ScaleTitle -> Encode.Value
encodeScaleTitle title =
    Encode.beginObject
        |> Encode.boolField "display" True
        |> Encode.stringField "text" title.text
        |> Encode.maybeColorField "color" title.color
        |> Encode.maybeCustomField "font" encodeFont title.font
        |> Encode.maybeIntField "padding" title.padding
        |> Encode.toValue


encodeTicks : Chartjs.Options.Scale.ScaleTicks -> Encode.Value
encodeTicks ticks =
    Encode.beginObject
        |> Encode.maybeColorField "backdropColor" ticks.backdropColor
        |> Encode.maybeIntField "backdropPadding" ticks.backdropPadding
        |> Encode.maybeCustomField "showLabelBackdrop" (\_ -> Encode.bool True) ticks.backdropColor
        |> Encode.maybeBoolField "display" ticks.display
        |> Encode.maybeColorField "color" ticks.color
        |> Encode.maybeCustomField "font" encodeFont ticks.font
        |> Encode.maybeIntField "padding" ticks.padding
        |> Encode.maybeColorField "textStrokeColor" ticks.textStrokeColor
        |> Encode.maybeIntField "textStrokeWidth" ticks.textStrokeWidth
        |> Encode.maybeIntField "z" ticks.z
        |> Encode.maybeFloatField "stepSize" ticks.stepSize
        |> Encode.maybeCustomField "tickFormat" encodeTickFormat ticks.tickFormat
        |> Encode.toValue


encodeTickFormat : Chartjs.Options.Scale.TickFormat -> Encode.Value
encodeTickFormat tickFormat =
    case tickFormat of
        Chartjs.Options.Scale.Prefix prefix ->
            Encode.object [ ( "prefix", Encode.string prefix ) ]

        Chartjs.Options.Scale.Suffix suffix ->
            Encode.object [ ( "suffix", Encode.string suffix ) ]


encodeTitle : Chartjs.Options.Title.Title -> Encode.Value
encodeTitle title =
    Encode.beginObject
        |> Encode.maybeBoolField "display" title.display
        |> Encode.maybeCustomField "align" encodeAlign title.align
        |> Encode.maybeCustomField "position" encodePosition title.position
        |> Encode.maybeIntField "padding" title.padding
        |> Encode.maybeStringField "text" title.text
        |> Encode.maybeCustomField "font" encodeFont title.font
        |> Encode.maybeColorField "color" title.color
        |> Encode.toValue


encodeTooltips : Chartjs.Options.Tooltips.Tooltips -> Encode.Value
encodeTooltips tooltips =
    Encode.beginObject
        |> Encode.maybeBoolField "enabled" tooltips.enabled
        |> Encode.maybeCustomField "mode" encodeMode tooltips.mode
        |> Encode.maybeBoolField "intersect" tooltips.intersect
        |> Encode.maybeCustomField "position" encodePositionMode tooltips.position
        |> Encode.maybeCustomField "labelFormat" encodeLabelFormat tooltips.labelFormat
        |> Encode.maybeColorField "backgroundColor" tooltips.backgroundColor
        |> Encode.maybeColorField "titleColor" tooltips.titleColor
        |> Encode.maybeCustomField "titleFont" encodeFont tooltips.titleFont
        |> Encode.maybeCustomField "titleAlign" encodeTooltipAlign tooltips.titleAlign
        |> Encode.maybeIntField "titleSpacing" tooltips.titleSpacing
        |> Encode.maybeIntField "titleMarginBottom" tooltips.titleMarginBottom
        |> Encode.maybeColorField "bodyColor" tooltips.bodyColor
        |> Encode.maybeCustomField "bodyFont" encodeFont tooltips.bodyFont
        |> Encode.maybeCustomField "bodyAlign" encodeTooltipAlign tooltips.bodyAlign
        |> Encode.maybeIntField "bodySpacing" tooltips.bodySpacing
        |> Encode.maybeStringField "footerText" tooltips.footerText
        |> Encode.maybeColorField "footerColor" tooltips.footerColor
        |> Encode.maybeCustomField "footerFont" encodeFont tooltips.footerFont
        |> Encode.maybeCustomField "footerAlign" encodeTooltipAlign tooltips.footerAlign
        |> Encode.maybeIntField "footerSpacing" tooltips.footerSpacing
        |> Encode.maybeIntField "footerMarginTop" tooltips.footerMarginTop
        |> Encode.maybeIntField "caretPadding" tooltips.caretPadding
        |> Encode.maybeIntField "caretSize" tooltips.caretSize
        |> Encode.maybeIntField "cornerRadius" tooltips.cornerRadius
        |> Encode.maybeColorField "multiKeyBackground" tooltips.multiKeyBackground
        |> Encode.maybeBoolField "displayColors" tooltips.displayColors
        |> Encode.maybeColorField "borderColor" tooltips.borderColor
        |> Encode.maybeIntField "borderWidth" tooltips.borderWidth
        |> Encode.toValue


encodeMode : Chartjs.Options.Tooltips.Mode -> Encode.Value
encodeMode mode =
    (case mode of
        Chartjs.Options.Tooltips.Point ->
            "point"

        Chartjs.Options.Tooltips.Nearest ->
            "nearest"

        Chartjs.Options.Tooltips.Index ->
            "index"

        Chartjs.Options.Tooltips.DataSet ->
            "dataset"

        Chartjs.Options.Tooltips.X ->
            "x"

        Chartjs.Options.Tooltips.Y ->
            "y"
    )
        |> Encode.string


encodePositionMode : Chartjs.Options.Tooltips.PositionMode -> Encode.Value
encodePositionMode positionMode =
    (case positionMode of
        Chartjs.Options.Tooltips.PositionModeAverage ->
            "average"

        Chartjs.Options.Tooltips.PositionModeNearest ->
            "nearest"
    )
        |> Encode.string


encodeTooltipAlign : Chartjs.Options.Tooltips.TooltipTextAlign -> Encode.Value
encodeTooltipAlign align =
    (case align of
        Chartjs.Options.Tooltips.Left ->
            "left"

        Chartjs.Options.Tooltips.Center ->
            "center"

        Chartjs.Options.Tooltips.Right ->
            "right"
    )
        |> Encode.string


encodeLabelFormat : Chartjs.Options.Tooltips.LabelFormat -> Encode.Value
encodeLabelFormat labelFormat =
    case labelFormat of
        Chartjs.Options.Tooltips.Prefix prefix ->
            Encode.object [ ( "prefix", Encode.string prefix ) ]

        Chartjs.Options.Tooltips.Suffix suffix ->
            Encode.object [ ( "suffix", Encode.string suffix ) ]
