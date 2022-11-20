local Translations = {
    success = {
        hunger_set = 'Fitbit: Alerte de faim fixée à %{hungervalue}%',
        thirst_set = 'Fitbit: Alerte de soif fixée à %{thirstvalue}%',
    },
    warning = {
        hunger_warning = 'Votre faim est %{hunger}%',
        thirst_warning = 'Votre soif est %{thirst}%'
    },
    info = {
        fitbit = 'FITBIT '
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
