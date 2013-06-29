<?php
/*
стандартно
'name' => 'name'
<xsl:apply-templates select="/page/head/msg/name" />

с html
'name' => htmlspecialchars('<b>name</b>')
<xsl:value-of disable-output-escaping="yes" select="/page/head/msg/trafic_cat_help" />
*/
$messageList = array(
    'old_code_warning' => '<p><strong>Переход на новый код блока</strong></p><p>Наша рекламная сеть переходит на новую, улучшенную версию кода блока. У вас продолжает показываться старый код. Просим произвести замену до %%DEADLINE%% (иначе блоки перестанут отображаться). Новые коды, инструкции по их установке и статус по каждому сайту вы можете найти в разделе «<a href="/site/siteList/">Сайты и блоки</a>».</p>',
    'no_money' => 'На вашем балансе нет средств, показ рекламы остановлен.',
    'refill_account' => 'Пополнить счет',
    '_1_day' => 'день',
    '_2_day' => 'дня',
    '_3_day' => 'дней',
    '_1_rub' => 'рубль',
    '_2_rub' => 'рубля',
    '_3_rub' => 'рублей',
    'no_money_in_days' => 'Средства на вашем балансе закончатся примерно через %%DAY_COUNT%% %%DAY_STR%%. После этого показ всех объявлений будет остановлен.',
    'no_money_in_minutes' => 'Средства на вашем балансе закончатся примерно через с минуты на минуту. После этого показ всех объявлений будет остановлен.',
    '_short_time' => 'с минуты на минуту',
    '_approx_from' => 'примерно через ',
    'sites_ending' => 'ы',

    'menu_campaign_list_title' => 'Реклама в сети «Охват»',

    'head_your_login' => 'Ваш логин',
    'head_logout'     => 'выйти',
    'head_user_blocked' => 'Пользователь заблокирован',
    'head_user' => 'Пользователь',
    'head_edit_user' => 'редактировать',
    'head_return_from_user' => 'вернуться',
    'head_view_mode' => 'Режим просмотра',
    'head_simple_mode' => 'простой',
    'head_extended_mode' => 'расширенный',
    'head_balance' => 'Баланс',
    'head_cur' => 'руб.',
    'head_balance_recharge' => 'пополнить',
    'head_balance_recount' => 'Идет расчет баланса...',
    'head_reserve' => 'Зарезервировано',
    'head_to_pay_out' => 'Сумма к выплате',
    'head_credit_limit' => 'Кредитный лимит',

    'yes' => 'Да',
    'no' => 'Нет',

    'Login' => 'Логин',
    'Pass' => 'Пароль',
    'Comment' => 'Комментарий',
    'Details' => 'Подробнее',
    'Help' => 'Помощь',
    'Edit' => 'Редактировать',
    'Send' => 'Отправить',
    'Ok' => 'Ок',
    'Cancel' => 'Отмена',
    'Save' => 'Сохранить',
    'Add' => 'Добавить',
    'Status' => 'Статус',
    'Change' => 'Изменить',
    'js_Change' => 'Изменить',
    'Deleted' => 'Удаленные',
    'all' => 'Все',

    'delete' => 'удалить',

    'Algos' => 'Алгоритмы',
    'view_stat' => 'Посмотреть статистику',

    'site_status_0' => 'Сайт заблокирован',
    'site_status_1' => '',
    'site_status_2' => 'Находится на модерации',
    'site_status_3' => 'Сайт отклонен',
    'site_status_4' => 'Находится на модерации',
    'site_status_5' => 'Ожидание',
    'site_status_6' => 'Необходимо подтвердить права доступа к сайту',

    'missing_statistics_url' => 'Укажите URL статистики',
    'missing_statistics_login' => 'Укажите логин статистики',
    'missing_statistics_password' => 'Укажите пароль статистики',
    'statistics_url' => 'URL статистики',
    'statistics_is_protected' => 'Статистика закрыта, требуется логин/пароль',

    'For_webmaster' => 'Для вебмастера',
    'Sites' => 'Сайты',
    'Filters' => 'Фильтры',
    'Filters_apply' => 'Применить',

    'month_list' => 'января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря',
    'month_in_nom_list' => 'Январь|Февраль|Март|Апрель|Май|Июнь|Июль|Август|Сентябрь|Октябрь|Ноябрь|Декабрь',

    'Monday' => 'Понедельник',
    'Tuesday' => 'Вторник',
    'Wednesday' => 'Среда',
    'Thursday' => 'Четверг',
    'Friday' => 'Пятница',
    'Saturday' => 'Суббота',
    'Sunday' => 'Воскресенье',

    'today' => 'сегодня',
    'cur_week' => 'текущая неделя',
    'cur_month' => 'текущий месяц',
    'incompl_week' => 'неполная неделя',
    'incompl_month' => 'неполный месяц',
    'general_word_from' => 'с',
    'general_word_till' => 'по',
    'general_word_From' => 'С',
    'general_word_Till' => 'По',

    'targeting_Query' => 'Поисковый',
    'targeting_Audience' => 'Аудиторный',
    'targeting_Unknown' => 'Неизвестный',
    'targeting_Off' => 'Отключен',

    'name_sources' => 'Источники',
    'shtuk' => 'шт.',

    'head_campaign' => 'Кампания',
    'not_change' => 'Не изменять',
    'not_chosen_female' => 'Не выбрана',

    'Attention' => 'Внимание!',
    'Copy' => 'Скопировать',
    'Action' => 'Действие',

    'and' => 'и',

    'Enabled_male' => 'Включен',
    'Disabled_male' => 'Выключен',
    'not_configured_male' => 'не настроен',
    'configured_male' => 'настроен',
    'not_configured_plural' => 'не настроены',
    'configured_plural' => 'настроены',
    'Not_configured_plural' => 'не настроены',

    'Schedule' => 'Расписание',
    'Limits_by_days' => 'Лимиты по дням',
    'Distribution' => 'Распределение',
    'Geotargeting' => 'Геотаргетинг',
    'Zones' => 'Зоны',
    'by_sources' => 'Статистика по источникам',
    'by_geo' => 'Статистика по географии',
    'by_query_phrases' => 'Статистика по поисковым словам',

    /* ПЛАНИРОВЩИК ЛИМИТОВ */
    'limits_planner' => 'Планировщик лимитов',
    'js_limits_planner' => 'Планировщик лимитов',
    'js_limits_planner_loading' => 'Подождите, идёт загрузка',

    'Stop' => 'Остановить',
    'Start' => 'Запустить',

    'Tizers' => 'Объявления',
    'Loading' => 'Загрузка',
    'js_Loading' => 'Загрузка',

    'js_added_category' => 'Доп. тематика',
    'js_Ok' => 'Ок',
    'js_Geotargeting' => 'Геотаргетинг',
    'js_Geotargeting_loading' => 'Подождите, идёт загрузка дерева',
    'js_Zones' => 'Зоны',
    'js_Zones_loading' => 'Подождите, идёт загрузка зон',
    'currency_short' => 'руб.',
    'js_currency_short' => 'руб.',

    'mon' => 'пн',
    'tue' => 'вт',
    'wed' => 'ср',
    'thu' => 'чт',
    'fri' => 'пт',
    'sat' => 'сб',
    'sun' => 'вс',

    'premium' => 'премиум',

    'Month' => 'Месяц',
    'Year' => 'Год',

    'Next_month' => 'Следующий месяц',
    'Previous_month' => 'Предыдущий месяц',

    'limits_planner_both_limits_hint' => 'Если Вы установили лимит как по количеству переходов так и по дневному бюджету, то сработает тот лимит, который будет достигнут первым.',
    'limits_planner_legend' => 'Условные обозначения',
    'limits_planner_legend_hits' => 'установлен лимит на количество кликов',
    'limits_planner_legend_budget' => 'установлен лимит бюджета (в рублях)',
    'limits_planner_legend_several_days' => 'лимит, действующий на протяжении нескольких дней',
    'limits_planner_legend_weekly_limit' => 'еженедельный лимит, действует только в определенный день недели и имеет приоритет над другими лимитами',
    'limits_planner_legend_stopped' => 'рекламная кампания остановлена, объявления не будут показываться',

    'limits_planner_faq' => htmlspecialchars('<h4>Как запланировать лимит?</h4><ol><li value="1">Выберите месяц, в котором хотите запланировать лимит</li><li value="2">Кликните на ячейку, соответствующую нужной дате</li><li value="3">В появившемся окне нажмите на ссылку "Не назначен"</li><li value="4">В поле задайте лимит и нажмите "Ок"</li><li value="5">Лимит будет автоматически установлен в указанный день и будет действовать до тех пор, пока вы его не отмените</li></ol><h4>Как отменить запланированный лимит?</h4><ol class="last"><li value="1">Кликните на ячейку того дня, в который вы хотите отменить лимит</li><li value="2">В появившемся окне нажмите на ссылку "Снять" напротив лимита</li><li value="3">Когда наступит указанный день, лимит будет автоматически снят</li></ol>'),

    'Monday_d' => 'Понедельникам',
    'Tuesday_d' => 'Вторникам',
    'Wednesday_d' => 'Средам',
    'Thursday_d' => 'Четвергам',
    'Friday_d' => 'Пятницам',
    'Saturday_d' => 'Субботам',
    'Sunday_d' => 'Воскресениям',

    'Take_off' => 'снять',
    'Set_other' => 'Назначить другой',

    'Enabled_female' => 'Включена',
    'Disabled_female' => 'Выключена',

    'Site_status' => 'Статус сайта',
    'Campaign_status' => 'Статус рекламной кампании',
    'Acting_limits' => 'Действующие лимиты',

    'geo_min_price_p1' => 'Для включении геотаргетинга минимальная цена клика составляет',
    'geo_min_price_p2' => 'будет автоматически установлена наценка.',
    'geo_min_price_p3' => 'В объявлениях с ценой клика менее',
    'new_geo_set' => 'Назначен следующий геосостав',
    'Clear_all' => 'Очистить все',
    'geo_russia_part' => 'Россия не менее 60%',
    'geo_percent_error' => 'Невозможно назначить %. Сумма процентов не должна превышать 100',
    'geo_percent_set' => 'Назначить % трафика',
    'cpc_not_less' => 'цена клика не менее',

    'turn_on' => 'Включить',
    'turn_off' => 'Выключить',

    'label_name' => 'Название',
    'label_url' => 'URL',
    'label_description' => 'Описание',
    'label_password' => 'Пароль',

    'title_partnership' => 'Партнерская программа',
    'title_registration' => 'Регистрация'
);