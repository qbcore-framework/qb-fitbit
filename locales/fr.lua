local Translations = {
    success = {
        hunger_set = 'Fitbit: Alerte faim à : %{hungervalue}%',
        thirst_set = 'Fitbit: Alerte soif à : %{thirstvalue}%',
    },
    warning = {
        hunger_warning = 'Votre faim est de : %{hunger}%',
        thirst_warning = 'Votre soif est de : %{thirst}%'
    },
    info = {
        fitbit = 'FITBIT '
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
