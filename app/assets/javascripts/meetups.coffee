DOM = React.DOM

CreateNewMeetupForm = React.createClass
  getInitialState: ->
    {
      title: ""
      description: ""
    }

  titleChanged: (event) ->
    @setState(title: event.target.value)
