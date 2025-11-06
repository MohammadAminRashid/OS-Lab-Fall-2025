#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

const int max_num_of_digits = 15;

vector<long long> generate_reference_numbers(int i = 1)
{
    if (i > max_num_of_digits)
        return {};

    long long reference_number = 0;
    for (int j = 0; j < i; j++)
    {
        reference_number = reference_number * 10 + 1;
    }

    vector<long long> reference_numbers = generate_reference_numbers(i + 1);
    reference_numbers.insert(reference_numbers.begin(), reference_number);

    return reference_numbers;
}

int num_of_digits(long long num, int count = 0)
{
    if (num != 0)
    {
        num /= 10;
        count++;
        return num_of_digits(num, count);
    }
    else
        return count;
}

void recursive_solve(long long number, vector<long long> reference_numbers, int sum_of_digits = 0)
{
    long long closest_number = reference_numbers[0];
    for (int i = 0; i < 15; i++)
    {
        if (abs(number - reference_numbers[i]) < abs(number - closest_number))
        {
            closest_number = reference_numbers[i];
        }
    }
    sum_of_digits += num_of_digits(closest_number);

    number = abs(number - closest_number);

    if (number == 0)
    {
        cout << sum_of_digits;
    }
    else
    {
        recursive_solve(number, reference_numbers, sum_of_digits);
    }
}

int main()
{
    long long number;
    cin >> number;

    vector<long long> reference_numbers = generate_reference_numbers();

    recursive_solve(number, reference_numbers);

    return 0;
}