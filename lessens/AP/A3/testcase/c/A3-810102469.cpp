#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>

using namespace std;

const string FILE_ERROR = "Unable to open file: ";
const string FIRSTE_EXPENSE_TYPE = "equally";
const string SECOND_EXPENSE_TYPE = "unequally";
const string THIRD_EXPENSE_TYPE = "adjustment";
const double DECIMAL_SCALE = 100;

struct Expense
{
    string type;
    vector<string> payers;
    vector<int> payments;
    vector<string> borrowers;
    vector<int> loans;
};

struct Payment
{
    string creditor;
    string debtor;
    double money;
};

void trim_string(string &str)
{
    str.erase(str.begin(), find_if(str.begin(), str.end(), [](unsigned char ch)
                                   { return !isspace(ch); }));
    str.erase(find_if(str.rbegin(), str.rend(), [](unsigned char ch)
                      { return !isspace(ch); })
                  .base(),
              str.end());
}

void truncate_to_2_decimal_places(double &number)
{
    number = (floor(number * DECIMAL_SCALE)) / DECIMAL_SCALE;
    number = (round(number * DECIMAL_SCALE)) / DECIMAL_SCALE;
}

int calculate_the_sum(vector<int> numbers)
{
    int sum = 0;
    for (int i = 0; i < numbers.size(); i++)
    {
        sum += numbers[i];
    }
    return sum;
}

void create_users(vector<pair<string, double>> &users, string usersFile)
{
    ifstream file(usersFile);
    if (!file.is_open())
    {
        cerr << FILE_ERROR << usersFile << endl;
        return;
    }

    string header;
    getline(file, header);

    string user;
    while (getline(file, user))
    {
        users.push_back({user, 0});
    }

    file.close();
}

void convert_the_expenses_file_to_vector(vector<string> &lines, string expensesFile)
{
    ifstream file(expensesFile);
    if (!file.is_open())
    {
        cerr << FILE_ERROR << expensesFile << endl;
    }

    string header;
    getline(file, header);

    string line;
    while (getline(file, line))
    {
        lines.push_back(line);
    }

    file.close();
}

void create_expenses_type(vector<Expense> &expenses, vector<string> lines)
{
    Expense expense;
    for (int i = 0; i < lines.size(); i++)
    {
        int pos = lines[i].find(',');
        expense.type = lines[i].substr(0, pos);
        expenses.push_back(expense);
    }
}

void create_expenses_payers_and_payments(vector<Expense> &expenses, vector<string> lines)
{
    for (int i = 0; i < lines.size(); i++)
    {
        int firstPos = lines[i].find(',');
        int secondPos = lines[i].find(',', firstPos + 1);
        string payers_and_payments = ";" + lines[i].substr(firstPos + 1, secondPos - firstPos - 1) + ";";

        int startPos = 0;
        int endPos = 0;
        while (true)
        {
            startPos = payers_and_payments.find(';', endPos);
            if (startPos == payers_and_payments.size() - 1)
                break;
            endPos = payers_and_payments.find(':', startPos);
            string payer = payers_and_payments.substr(startPos + 1, endPos - startPos - 1);
            expenses[i].payers.push_back(payer);
        }
        startPos = 0;
        endPos = 0;

        while (true)
        {
            startPos = payers_and_payments.find(':', endPos);
            if (endPos == payers_and_payments.size() - 1)
                break;
            endPos = payers_and_payments.find(';', startPos);
            string payment = payers_and_payments.substr(startPos + 1, endPos - startPos - 1);
            expenses[i].payments.push_back(stoi(payment));
        }
    }
}

void create_expenses_borrowers_and_loans(vector<Expense> &expenses, vector<string> lines)
{
    for (int i = 0; i < lines.size(); i++)
    {
        int firstPos = lines[i].find(',');
        int secondPos = lines[i].find(',', firstPos + 1);
        if (secondPos == lines[i].size() - 2)
            continue;
        string borrowers_and_loans = ";" + lines[i].substr(secondPos + 1) + ";";

        int startPos = 0;
        int endPos = 0;

        if (expenses[i].type == FIRSTE_EXPENSE_TYPE)
        {
            while (true)
            {
                endPos = borrowers_and_loans.find(';', startPos + 1);
                string borrower = borrowers_and_loans.substr(startPos + 1, endPos - startPos - 1);
                expenses[i].borrowers.push_back(borrower);
                startPos = endPos;
                if (startPos == borrowers_and_loans.size() - 1)
                    break;
            }
        }
        else
        {
            while (true)
            {
                startPos = borrowers_and_loans.find(';', endPos);
                if (startPos == borrowers_and_loans.size() - 1)
                    break;
                endPos = borrowers_and_loans.find(':', startPos);
                string borrower = borrowers_and_loans.substr(startPos + 1, endPos - startPos - 1);
                expenses[i].borrowers.push_back(borrower);
            }
            startPos = 0;
            endPos = 0;
            while (true)
            {
                startPos = borrowers_and_loans.find(':', endPos);
                if (endPos == borrowers_and_loans.size() - 1)
                    break;
                endPos = borrowers_and_loans.find(';', startPos);
                string loans = borrowers_and_loans.substr(startPos + 1, endPos - startPos - 1);
                expenses[i].loans.push_back(stoi(loans));
            }
        }
    }
}

void calculate_payers_accounts(vector<Expense> &expenses, vector<pair<string, double>> &users)
{
    for (int i = 0; i < expenses.size(); i++)
    {
        for (int j = 0; j < expenses[i].payers.size(); j++)
        {
            for (int k = 0; k < users.size(); k++)
            {
                trim_string(expenses[i].payers[j]);
                trim_string(users[k].first);
                if (expenses[i].payers[j] == users[k].first)
                {
                    users[k].second += expenses[i].payments[j];
                }
            }
        }
    }
}

void calculate_borrowers_accounts_equally(vector<Expense> &expenses, vector<pair<string, double>> &users)
{
    double sum_payments;
    int number;
    double accounts;
    double last_accounts;

    for (int i = 0; i < expenses.size(); i++)
    {
        int is_borrowers_empty = 1;
        if (expenses[i].type == FIRSTE_EXPENSE_TYPE)
        {
            if (expenses[i].borrowers.empty())
                is_borrowers_empty = 0;
            if (!expenses[i].borrowers.empty() && expenses[i].borrowers[0].empty())
                is_borrowers_empty = 0;
            if (is_borrowers_empty == 1)
            {
                sum_payments = calculate_the_sum(expenses[i].payments);
                number = expenses[i].borrowers.size();
                accounts = sum_payments / number;
                truncate_to_2_decimal_places(accounts);
                last_accounts = sum_payments - ((number - 1) * accounts);

                for (int j = 0; j < expenses[i].borrowers.size() - 1; j++)
                {
                    for (int k = 0; k < users.size(); k++)
                    {
                        trim_string(expenses[i].borrowers[j]);
                        trim_string(users[k].first);
                        if (expenses[i].borrowers[j] == users[k].first)
                            users[k].second -= accounts;
                    }
                }
                for (int k = 0; k < users.size(); k++)
                {
                    trim_string(expenses[i].borrowers.back());
                    trim_string(users[k].first);
                    if (expenses[i].borrowers.back() == users[k].first)
                        users[k].second -= last_accounts;
                }
            }
            else
            {
                sum_payments = calculate_the_sum(expenses[i].payments);
                number = users.size();
                accounts = sum_payments / number;
                truncate_to_2_decimal_places(accounts);
                last_accounts = sum_payments - ((number - 1) * accounts);

                for (int j = 0; j < users.size() - 1; j++)
                {
                    users[j].second -= accounts;
                }
                users.back().second -= last_accounts;
            }
        }
    }
}

void calculate_borrowers_accounts_unequally(vector<Expense> &expenses, vector<pair<string, double>> &users)
{
    for (int i = 0; i < expenses.size(); i++)
    {
        if (expenses[i].type == SECOND_EXPENSE_TYPE)
        {
            for (int j = 0; j < expenses[i].borrowers.size(); j++)
            {
                for (int k = 0; k < users.size(); k++)
                {
                    trim_string(expenses[i].borrowers[j]);
                    trim_string(users[k].first);
                    if (expenses[i].borrowers[j] == users[k].first)
                    {
                        users[k].second -= expenses[i].loans[j];
                    }
                }
            }
        }
    }
}

void calculate_borrowers_accounts_adjustment(vector<Expense> &expenses, vector<pair<string, double>> &users)
{
    double sum_payments;
    int number;
    double accounts;
    double last_accounts;

    for (int i = 0; i < expenses.size(); i++)
    {
        if (expenses[i].type == THIRD_EXPENSE_TYPE)
        {
            sum_payments = calculate_the_sum(expenses[i].payments) - calculate_the_sum(expenses[i].loans);
            number = users.size();
            accounts = sum_payments / number;
            truncate_to_2_decimal_places(accounts);
            last_accounts = sum_payments - ((number - 1) * accounts);

            for (int j = 0; j < users.size(); j++)
            {
                trim_string(users[j].first);
                trim_string(expenses[i].borrowers.back());
                if (users[j].first == expenses[i].borrowers.back())
                    users[j].second -= last_accounts;
                else
                    users[j].second -= accounts;
            }

            for (int j = 0; j < expenses[i].borrowers.size(); j++)
            {
                for (int k = 0; k < users.size(); k++)
                {
                    trim_string(expenses[i].borrowers[j]);
                    trim_string(users[k].first);
                    if (expenses[i].borrowers[j] == users[k].first)
                    {
                        users[k].second -= expenses[i].loans[j];
                    }
                }
            }
        }
    }
}

bool sort_by_name(string firstName, string secondName)
{
    int minLength = min(firstName.length(), secondName.length());

    for (int i = 0; i < minLength; ++i)
    {
        if (firstName[i] < secondName[i])
            return true;

        else if (firstName[i] > secondName[i])
            return false;
    }

    return firstName.length() < secondName.length();
}

void separation_of_creditors_and_debtors(vector<pair<string, double>> &creditors, vector<pair<string, double>> &debtors, vector<pair<string, double>> users)
{
    for (int i = 0; i < users.size(); i++)
    {
        if (users[i].second >= 0)
            creditors.push_back(users[i]);
        if (users[i].second < 0)
            debtors.push_back(users[i]);
    }
}

void sort_creditors_and_debtors(vector<pair<string, double>> &creditors, vector<pair<string, double>> &debtors)
{
    vector<pair<string, double>> temp_creditors;
    vector<pair<string, double>> temp_debtors;
    pair<string, double> firstCreditor;
    pair<string, double> firstDebtor;

    while (!creditors.empty())
    {
        int indexToRemove = 0;
        firstCreditor = creditors[0];
        for (int i = 0; i < creditors.size() - 1; i++)
        {
            if (creditors[i + 1].second > firstCreditor.second)
            {
                firstCreditor = creditors[i + 1];
                indexToRemove = i + 1;
            }
            else if (creditors[i + 1].second == firstCreditor.second)
            {
                if (sort_by_name(creditors[i + 1].first, firstCreditor.first))
                {
                    firstCreditor = creditors[i + 1];
                    indexToRemove = i + 1;
                }
            }
        }
        temp_creditors.push_back(firstCreditor);
        creditors.erase(creditors.begin() + indexToRemove);
    }
    creditors = temp_creditors;

    while (!debtors.empty())
    {
        int indexToRemove = 0;
        firstDebtor = debtors[0];
        for (int i = 0; i < debtors.size() - 1; i++)
        {
            if (debtors[i + 1].second < firstDebtor.second)
            {
                firstDebtor = debtors[i + 1];
                indexToRemove = i + 1;
            }
            else if (debtors[i + 1].second == firstDebtor.second)
            {
                if (sort_by_name(debtors[i + 1].first, firstDebtor.first))
                {
                    firstDebtor = debtors[i + 1];
                    indexToRemove = i + 1;
                }
            }
        }
        temp_debtors.push_back(firstDebtor);
        debtors.erase(debtors.begin() + indexToRemove);
    }
    debtors = temp_debtors;
}

void create_payments(vector<pair<string, double>> &creditors, vector<pair<string, double>> &debtors, vector<Payment> &payments)
{

    Payment payment;
    double demand, debt, sum;
    int counter = 0;
    int i, j;
    for (i = 0; i < creditors.size(); i++)
    {
        if (creditors[i].second == 0)
        {
            counter += 1;
        }
    }
    if (counter == creditors.size())
        return;

    for (i = 0; i < creditors.size(); i++)
    {
        if (creditors[i].second != 0)
        {
            demand = creditors[i].second;
            break;
        }
    }
    for (j = 0; j < debtors.size(); j++)
    {
        if (debtors[j].second != 0)
        {
            debt = debtors[j].second;
            break;
        }
    }

    sum = demand + debt;
    if (sum > -0.01 && sum < 0.01)
        sum = 0;

    if (sum >= 0)
    {
        creditors[i].second = sum;
        debtors[j].second = 0;
        payment.creditor = creditors[i].first;
        payment.debtor = debtors[j].first;
        payment.money = -1 * debt;
        payments.push_back(payment);
    }
    else if (sum < 0)
    {
        creditors[i].second = 0;
        debtors[j].second = sum;
        payment.creditor = creditors[i].first;
        payment.debtor = debtors[j].first;
        payment.money = demand;
        payments.push_back(payment);
    }
    create_payments(creditors, debtors, payments);
}

void sort_payments(vector<Payment> &payments)
{
    vector<Payment> temp_payments;
    Payment firstPayment;

    while (!payments.empty())
    {
        int indexToRemove = 0;
        firstPayment = payments[0];

        for (int i = 0; i < payments.size() - 1; i++)
        {
            if (payments[i + 1].money > firstPayment.money)
            {
                firstPayment = payments[i + 1];
                indexToRemove = i + 1;
            }
            else if (payments[i + 1].money == firstPayment.money)
            {
                if (sort_by_name(payments[i + 1].debtor, firstPayment.debtor))
                {
                    firstPayment = payments[i + 1];
                    indexToRemove = i + 1;
                }
                if (payments[i + 1].debtor == firstPayment.debtor)
                {
                    if (sort_by_name(payments[i + 1].creditor, firstPayment.creditor))
                    {
                        firstPayment = payments[i + 1];
                        indexToRemove = i + 1;
                    }
                }
            }
        }

        temp_payments.push_back(firstPayment);
        payments.erase(payments.begin() + indexToRemove);
    }

    payments = temp_payments;
}

void print_payments(vector<Payment> &payments)
{
    for (int i = 0; i < payments.size(); i++)
    {
        cout << payments[i].debtor << " -> " << payments[i].creditor << ": " << payments[i].money << endl;
    }
}

int main(int argc, char *argv[])
{
    const string usersFile = argv[1];
    const string expensesFile = argv[2];

    vector<string> lines;
    vector<Expense> expenses;
    vector<pair<string, double>> users;
    vector<pair<string, double>> creditors;
    vector<pair<string, double>> debtors;
    vector<Payment> payments;

    convert_the_expenses_file_to_vector(lines, expensesFile);
    create_users(users, usersFile);
    create_expenses_type(expenses, lines);
    create_expenses_payers_and_payments(expenses, lines);
    create_expenses_borrowers_and_loans(expenses, lines);
    calculate_payers_accounts(expenses, users);
    calculate_borrowers_accounts_equally(expenses, users);
    calculate_borrowers_accounts_unequally(expenses, users);
    calculate_borrowers_accounts_adjustment(expenses, users);
    separation_of_creditors_and_debtors(creditors, debtors, users);
    sort_creditors_and_debtors(creditors, debtors);
    create_payments(creditors, debtors, payments);
    sort_payments(payments);
    print_payments(payments);
}