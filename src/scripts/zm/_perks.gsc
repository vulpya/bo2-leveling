changePerkLimit(amount)
{
    if (amount < 0)
        amount = 0;
    else if (amount > 9)
        amount = 9;

    level.perk_purchase_limit = amount;
    iprintln("Perk Limit: ^2" + amount);
}