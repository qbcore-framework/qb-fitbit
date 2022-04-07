local Translations = {
    success = {
        hunger_set = 'Fitbit: Hungerwarnung auf %{hungervalue}% eingestellt',
        thirst_set = 'Fitbit: Durstwarnung auf %{thirstvalue}% eingestellt',
    },
    warning = {
        hunger_warning = 'Dein Hunger beträgt %{hunger}%',
        thirst_warning = 'Dein Durst beträgt %{thirst}%'
    },
    info = {
        fitbit = 'FITBIT '
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
