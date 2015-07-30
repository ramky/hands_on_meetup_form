DOM = React.DOM

CreateNewMeetupForm = React.createClass
  displayName: "CreateNewMeetupForm"
  getInitialState: ->
    {
      title: ""
      description: ""
      date: new Date()
    }

  titleChanged: (event) ->
    @setState(title: event.target.value)

  descriptionChanged: (event) ->
    @setState(description: event.target.value)

  dateChanged: (newDate) ->
    @setState(date: newDate)

  formSubmitted: (event) ->
    event.preventDefault()

    $.ajax
      url: "/meetups.json",
      type: "POST",
      dataType: "JSON",
      contentType: "application/json",
      processData: false,
      data: JSON.stringify({meetup: {
        title: @state.title
        description: @state.description
        date: "#{@state.date.getFullYear()}-#{@state.date.getMonth()+1}-#{@state.date.getDate()}"
      }})

  render: ->
    DOM.form
      className: "form-horizontal"
      method: "post"
      action: "/meetups"
      onSubmit: @formSubmitted
      DOM.fieldset null,
        DOM.legend null, "New Meetup"

      formInputWithLabel
        id: "title"
        value: @state.title
        onChange: @titleChanged
        placeholder: "Meetup title"
        labelText: "Title"

      formInputWithLabel
        id: "description"
        value: @state.description
        onChange: @descriptionChanged
        placeholder: "Meetup description"
        labelText: "Description"

      dateWithLabel
        onChange: @dateChanged
        date: @state.date

      DOM.div
        className: "form-group"
        DOM.div
          className: "col-lg-10 col-lg-offset-2"
          DOM.button
            type: "submit"
            className: "btn btn-primary"
            "Save"

FormInputWithLabel = React.createClass
  displayName: "FormInputWithLabel"
  render: ->
    DOM.div
      className: "form-group"
      DOM.label
        htmlFor: @props.id
        className: "col-lg-2 control-label"
        @props.labelText
      DOM.div
        className: "col-lg-10"
        DOM.input
          className: "form-control"
          placeholder: @props.placeholder
          id: @props.id
          type: "text"
          value: @props.value
          onChange: @props.onChange

DateWithLabel = React.createClass
  getDefaultProps: ->
    date: new Date()

  onYearChange: (event) ->
    newDate = new Date(
      event.target.value,
      @props.date.getMonth(),
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onMonthChange: (event) ->
    newDate = new Date(
      @props.date.getFullYear(),
      event.target.value,
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onDateChange: (event) ->
    newDate = new Date(
      @props.date.getFullYear(),
      @props.date.getMonth(),
      event.target.value
    )
    @props.onChange(newDate)

  monthName: (monthNumberStartingFromZero) ->
    [
      "January", "February", "March", "April", "May", "June", "July",
      "August", "September", "October", "November", "December"
    ][monthNumberStartingFromZero]

  dayName: (date) ->
    dayNameStartingWithSundayZero = new Date(
      @props.date.getFullYear(),
      @props.date.getMonth(),
      date
    ).getDay()
    [
      "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ][dayNameStartingWithSundayZero]

  render: ->
    DOM.div
      className: "form-group"
      DOM.label
        className: "col-lg-2 control-label"
        "Date"
      DOM.div
        className: "col-lg-2"
        DOM.select
          className: "form-control"
          onChange: @onYearChange
          value: @props.date.getFullYear()
          DOM.option(value: year, key: year, year) for year in [2015..2020]
      DOM.div
        className: "col-lg-3"
        DOM.select
          className: "form-control"
          onChange: @onMonthChange
          value: @props.date.getMonth()
          DOM.option(value: month, key: month, "#{month+1}-#{@monthName(month)}") for month in [0..11]
      DOM.div
        className: "col-lg-2"
        onChange: @onDateChange
        DOM.select
          className: "form-control"
          value: @props.date.getDate()
          DOM.option(value: date, key: date, "#{date}-#{@dayName(date)}") for date in [1..31]

createNewMeetupForm = React.createFactory(CreateNewMeetupForm)
formInputWithLabel  = React.createFactory(FormInputWithLabel)
dateWithLabel       = React.createFactory(DateWithLabel)

$ ->
  React.render(
    createNewMeetupForm(),
      document.getElementById("CreateNewMeetup")
  )
