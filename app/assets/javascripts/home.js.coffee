window.templates = {}

jQuery ->
  # hbs helper for accouning.js
  Handlebars.registerHelper 'formatUSD', (data) -> accounting.formatMoney(data)

  # here we compile the templates for a speedy rendering
  $('script[type="text/x-handlebars-template"]').each ->
    templates[$(this).data('template')] = Handlebars.compile($(this).html())

  $('#note_amount, #note_rate, #note_term, #note_start_date').keyup -> loanSummary()
  $('#note_amount, #note_rate, #note_term, #note_start_date').change -> loanSummary()

loanSummary = ->
  amount = parseFloat($('#note_amount').val(), 10).toFixed(2)
  interest = parseFloat($('#note_rate').val(), 10).toFixed(3) / 100
  duration = parseInt($('#note_term').val(), 10)
  dateStart = moment($('#note_start_date').val(), 'YYYY-MM-DD')

  if amount > 0 and interest > 0 and duration > 0 and dateStart.isValid() is true
    installment = parseFloat(amount * (((interest / 12) * Math.pow(1 + (interest / 12), duration)) / (Math.pow(1 + (interest / 12), duration) - 1))).toFixed(2)

    $('#loan-summary').html(templates['loan-summary']
      duration: duration
      installment: installment
      totalInterest: (installment * duration) - amount
      totalPayments: installment * duration
      datePayoff: dateStart.clone().add('months', duration).format('MMM. YYYY')
    )

    #loanAmortization(amount, installment, interest, duration, dateStart)

loanAmortization = (amount, installment, interest, duration, dateStart) ->
  m = []
  y = {}

  totals =
    principal: parseFloat(amount, 10)
    interest: 0.00
    payment: 0.00

  for month in [duration..1]
    monthly_interest	= parseFloat(amount * (interest / 12), 10)
    monthly_principal	= parseFloat(installment - monthly_interest, 10)

    m.push
      date: dateStart.format('MMM. YYYY')
      principal: monthly_principal
      interest: monthly_interest
      payment: installment
      balance: if month is 1 then 0.00 else parseFloat(parseFloat(amount, 10) + parseFloat(monthly_interest, 10) - parseFloat(installment, 10), 10)

    year = dateStart.format('YYYY')

    if y.hasOwnProperty(year) isnt true
      y[year] = {
        date: year
        principal: 0.00
        interest: 0.00
        payment: 0.00
        balance: 0.00
      }

    y[year].principal += parseFloat(monthly_principal, 10)
    y[year].interest 	+= parseFloat(monthly_interest, 10)
    y[year].payment 	+= parseFloat(installment, 10)

    totals.interest		+= parseFloat(monthly_interest, 10)
    totals.payment		+= parseFloat(installment, 10)

    amount = parseFloat(amount - monthly_principal, 10)
    dateStart = dateStart.add('months', 1)

  for key, value of y
    y[key].balance = totals.principal
    y[key].balance = y[parseInt(key, 10) - 1].balance if y.hasOwnProperty(parseInt(key, 10) - 1) is true
    y[key].balance += parseFloat(value.interest, 10) - parseFloat(value.payment, 10)
    y[key].balance = 0.00 if y.hasOwnProperty(parseInt(key, 10) + 1) isnt true

  $('#amortization-yearly').html(templates['loan-amortization-yearly']({payments: y, totals: totals}))
  $('#amortization-monthly').html(templates['loan-amortization-monthly']({payments: m, totals: totals}))
