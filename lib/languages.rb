# -*- encoding : utf-8 -*-
class LanguageNames
    def self.get_language_name(locale)
        language_names = {
            'ab'	=> 'аҧсуа',
            'aa'	=> 'Afaraf',
            'af'	=> 'Afrikaans',
            'ak'	=> 'Akan',
            'sq'	=> 'Shqip',
            'am'	=> 'አማርኛ',
            'ar'	=> 'العربية',
            'an'	=> 'Aragonés',
            'hy'	=> 'Հայերեն',
            'as'	=> 'অসমীয়া',
            'av'	=> 'авар мацӀ',
            'ae'	=> 'avesta',
            'ay'	=> 'aymar aru',
            'az'	=> 'azərbaycan dili',
            'bm'	=> 'bamanankan',
            'ba'	=> 'башҡорт теле',
            'eu'	=> 'euskara',
            'be'	=> 'Беларуская',
            'bn'	=> 'বাংলা',
            'bh'	=> 'भोजपुरी',
            'bi'	=> 'Bislama',
            'bs'	=> 'bosanski jezik',
            'br'	=> 'brezhoneg',
            'bg'	=> 'български език',
            'my'	=> 'ဗမာစာ',
            'ca'	=> 'Català',
            'ch'	=> 'Chamoru',
            'ce'	=> 'нохчийн мотт',
            'ny'	=> 'chiCheŵa',
            'zh'	=> '中文 (Zhōngwén)',
            'zh-HK' => '中文(香港)',
            'cv'	=> 'чӑваш чӗлхи',
            'kw'	=> 'Kernewek',
            'co'	=> 'corsu',
            'cr'	=> 'ᓀᐦᐃᔭᐍᐏᐣ',
            'hr'	=> 'Hrvatski',
            'cs'	=> 'česky',
            'da'	=> 'dansk',
            'dv'	=> 'ދިވެހި',
            'nl'	=> 'Nederlands',
            'dz'	=> 'རྫོང་ཁ',
            'en'	=> 'English',
            'eo'	=> 'Esperanto',
            'et'	=> 'eesti',
            'ee'	=> 'Eʋegbe',
            'fo'	=> 'føroyskt',
            'fj'	=> 'vosa Vakaviti',
            'fi'	=> 'suomi',
            'fr'	=> 'français',
            'ff'	=> 'Fulfulde',
            'gl'	=> 'Galego',
            'ka'	=> 'ქართული',
            'de'	=> 'Deutsch',
            'el'	=> 'Ελληνικά',
            'gn'	=> 'Avañe\'ẽ',
            'gu'	=> 'ગુજરાતી',
            'ht'	=> 'Kreyòl ayisyen',
            'ha'	=> 'Hausa',
            'he'	=> 'עברית',
            'hz'	=> 'Otjiherero',
            'hi'	=> 'हिन्दी',
            'ho'	=> 'Hiri Motu',
            'hu'	=> 'Magyar',
            'ia'	=> 'Interlingua',
            'id'	=> 'Bahasa Indonesia',
            'ie'	=> 'Originally called Occidental; then Interlingue after WWII',
            'ga'	=> 'Gaeilge',
            'ig'	=> 'Asụsụ Igbo',
            'ik'	=> 'Iñupiaq',
            'io'	=> 'Ido',
            'is'	=> 'Íslenska',
            'it'	=> 'Italiano',
            'iu'	=> 'ᐃᓄᒃᑎᑐᑦ',
            'ja'	=> '日本語 (にほんご)',
            'jv'	=> 'basa Jawa',
            'kl'	=> 'kalaallisut',
            'kn'	=> 'ಕನ್ನಡ',
            'kr'	=> 'Kanuri',
            'ks'	=> 'कश्मीरी',
            'kk'	=> 'Қазақ тілі',
            'km'	=> 'ភាសាខ្មែរ',
            'ki'	=> 'Gĩkũyũ',
            'rw'	=> 'Ikinyarwanda',
            'ky'	=> 'кыргыз тили',
            'kv'	=> 'коми кыв',
            'kg'	=> 'KiKongo',
            'ko'	=> '한국어 (韓國語)',
            'ku'	=> 'Kurdî',
            'kj'	=> 'Kuanyama',
            'la'	=> 'latine',
            'lb'	=> 'Lëtzebuergesch',
            'lg'	=> 'Luganda',
            'li'	=> 'Limburgs',
            'ln'	=> 'Lingála',
            'lo'	=> 'ພາສາລາວ',
            'lt'	=> 'lietuvių kalba',
            'lu'	=> '',
            'lv'	=> 'latviešu valoda',
            'gv'	=> 'Gaelg',
            'mk'	=> 'македонски јазик',
            'mg'	=> 'Malagasy fiteny',
            'ms'	=> 'bahasa Melayu',
            'ml'	=> 'മലയാളം',
            'mt'	=> 'Malti',
            'mi'	=> 'te reo Māori',
            'mr'	=> 'मराठी',
            'mh'	=> 'Kajin M̧ajeļ',
            'mn'	=> 'монгол',
            'na'	=> 'Ekakairũ Naoero',
            'nv'	=> 'Diné bizaad',
            'nb'	=> 'Bokmål',
            'nd'	=> 'isiNdebele',
            'ne'	=> 'नेपाली',
            'ng'	=> 'Owambo',
            'nn'	=> 'Nynorsk',
            'no'	=> 'Norsk',
            'ii'	=> 'ꆈꌠ꒿ Nuosuhxop',
            'nr'	=> 'isiNdebele',
            'oc'	=> 'Occitan',
            'oj'	=> 'ᐊᓂᔑᓈᐯᒧᐎᓐ',
            'cu'	=> 'ѩзыкъ словѣньскъ',
            'om'	=> 'Afaan Oromoo',
            'or'	=> 'ଓଡ଼ିଆ',
            'os'	=> 'ирон æвзаг',
            'pa'	=> 'ਪੰਜਾਬੀ',
            'pi'	=> 'पाऴि',
            'fa'	=> 'فارسی',
            'pl'	=> 'polski',
            'ps'	=> 'پښتو',
            'pt'	=> 'Português',
            'qu'	=> 'Runa Simi',
            'rm'	=> 'rumantsch grischun',
            'rn'	=> 'Ikirundi',
            'ro'	=> 'română',
            'ru'	=> 'русский язык',
            'sa'	=> 'संस्कृतम्',
            'sc'	=> 'sardu',
            'sd'	=> 'सिन्धी',
            'se'	=> 'Davvisámegiella',
            'sm'	=> 'gagana fa\'a',
            'sg'	=> 'yângâ tî sängö',
            'sr'	=> 'српски језик',
            'gd'	=> 'Gàidhlig',
            'sn'	=> 'chiShona',
            'si'	=> 'සිංහල',
            'sk'	=> 'slovenčina',
            'sl'	=> 'slovenščina',
            'so'	=> 'Soomaaliga',
            'st'	=> 'Sesotho',
            'es'	=> 'español',
            'su'	=> 'Basa Sunda',
            'sw'	=> 'Kiswahili',
            'ss'	=> 'SiSwati',
            'sv'	=> 'svenska',
            'ta'	=> 'தமிழ்',
            'te'	=> 'తెలుగు',
            'tg'	=> 'тоҷикӣ',
            'th'	=> 'ไทย',
            'ti'	=> 'ትግርኛ',
            'bo'	=> 'བོད་ཡིག',
            'tk'	=> 'Türkmen',
            'tl'	=> 'Wikang Tagalog',
            'tn'	=> 'Setswana',
            'to'	=> 'faka Tonga',
            'tr'	=> 'Türkçe',
            'ts'	=> 'Xitsonga',
            'tt'	=> 'татарча',
            'tw'	=> 'Twi',
            'ty'	=> 'Reo Tahiti',
            'ug'	=> 'Uyƣurqə',
            'uk'	=> 'українська',
            'ur'	=> 'اردو',
            'uz'	=> 'O\'zbek',
            've'	=> 'Tshivenḓa',
            'vi'	=> 'Tiếng Việt',
            'vo'	=> 'Volapük',
            'wa'	=> 'Walon',
            'cy'	=> 'Cymraeg',
            'wo'	=> 'Wollof',
            'fy'	=> 'Frysk',
            'xh'	=> 'isiXhosa',
            'yi'	=> 'ייִדיש',
            'yo'	=> 'Yorùbá',
            'za'	=> 'Saɯ cueŋƅ',
            'zu'	=> 'isiZulu'
        }
        locale = locale.sub("_", "-") # normalize
        return language_names[locale] if language_names[locale]
        main_part = I18n::Locale::Tag::Simple.tag(locale).subtags[0]
        return language_names[main_part]
    end
end

