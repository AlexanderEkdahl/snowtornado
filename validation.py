def train_test_split(matches, ratio):
    return (
        matches[:round(matches.shape[0] * ratio)],
        matches[round(matches.shape[0] * ratio):]
    )

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
