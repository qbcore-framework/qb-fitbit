local Translations = {
    success = {
        hunger_set = 'Fitbit: Varování před hladem nastaveno na %{hungervalue}%',
        thirst_set = 'Fitbit: Upozornění na žízeň nastaveno na %{thirstvalue}%',
    },
    warning = {
        hunger_warning = 'Tvůj hlad je %{hunger}%',
        thirst_warning = 'Tvoje žízeň je %{thirst}%'
    },
    info = {
        fitbit = 'FITBIT '
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
