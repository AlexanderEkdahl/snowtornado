import matplotlib.pyplot as plt

def train_test_split(matches, ratio, stock_exchange):
    train = matches[:round(matches.shape[0] * ratio)]
    train = train.drop_duplicates(['original_id', 'replacement_id'])
    test = matches[round(matches.shape[0] * ratio):]

    mask = []
    for _, original, _, date in test.itertuples():
        stock_products = set(map((lambda x: x.data), stock_exchange[date]))
        if original not in stock_products:
            mask.append(original)

    test = test.loc[test['original_id'].isin(mask)]
    test = test.drop_duplicates(['original_id', 'replacement_id'])

    return train, test

def evaluate_model(model, test, find_all_matches):
    results = []

    for _, row in test.iterrows():
        original_id = row['original_id']
        replacement_id = row['replacement_id']
        timestamp = row['timestamp']

        matches = find_all_matches(model, original_id, timestamp)
        try:
            results.append((original_id, replacement_id, matches[0], matches.index(replacement_id)))
        except ValueError:
            # replacement_id was not in the stock data at that point
            pass

    return results

def less_than_percentage(xs, v):
    return '  {:.{prec}f}% less than {}'.format(len([x for x in xs if x < v]) / len(xs) * 100, v, prec=1);

def output_evaluation(model, matches_test, find_all_matches):
    ev = evaluate_model(model, matches_test, find_all_matches)

    positions = list(map(lambda x: x[3], ev))

    print(less_than_percentage(positions, 1))
    print(less_than_percentage(positions, 3))
    print(less_than_percentage(positions, 5))
    print(less_than_percentage(positions, 15))

def output_charts(model, matches_test, find_all_matches):
    ev = evaluate_model(model, matches_test, find_all_matches)

    positions = list(map(lambda x: x[3], ev))

    plt.hist(positions, bins=range(0, 25, 1))
    plt.show()
