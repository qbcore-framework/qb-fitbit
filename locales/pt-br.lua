local Translations = {
    success = {
        hunger_set = 'Fitbit: Alerta de fome definido para %{hungervalue}%',
        thirst_set = 'Fitbit: Alerta de sede definido para %{thirstvalue}%',
    },
    warning = {
        hunger_warning = 'Sua fome está em %{hunger}%',
        thirst_warning = 'Sua sede está em %{thirst}%'
    },
    info = {
        fitbit = 'FITBIT '
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
