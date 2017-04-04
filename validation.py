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

def evaluate_model(test, find_all_matches):
    results = []

    for _, row in test.iterrows():
        original_id = row['original_id']
        replacement_id = row['replacement_id']
        timestamp = row['timestamp']

        matches = find_all_matches(original_id, timestamp)
        try:
            results.append((original_id, replacement_id, matches[0], matches.index(replacement_id)))
        except ValueError:
            # replacement_id was not in the stock data at that point
            pass

    return results
