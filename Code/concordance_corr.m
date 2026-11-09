function ccc = concordance_corr(x, y)
% CONCORDANCE_CORR  Compute Lin's Concordance Correlation Coefficient (CCC)
%
%   ccc = concordance_corr(x, y)
%
%   Inputs:
%       x - vector of numeric values
%       y - vector of numeric values (same length as x)
%
%   Output:
%       ccc - scalar value of the CCC
%
%   Formula:
%       CCC = (2 * r * sigma_x * sigma_y) / ...
%             (sigma_x^2 + sigma_y^2 + (mu_x - mu_y)^2)
%
%   Where:
%       r       = Pearson correlation coefficient
%       sigma_x = standard deviation of x
%       sigma_y = standard deviation of y
%       mu_x    = mean of x
%       mu_y    = mean of y

    % --- Input validation ---
    if nargin ~= 2
        error('Two input arguments required: x and y.');
    end
    if ~isnumeric(x) || ~isnumeric(y)
        error('Inputs must be numeric.');
    end
    if ~isvector(x) || ~isvector(y)
        error('Inputs must be vectors.');
    end
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length.');
    end
    if length(x) < 2
        error('Vectors must contain at least two elements.');
    end

%     % Remove NaN values pairwise
%     validIdx = ~(isnan(x) | isnan(y));
%     x = x(validIdx);
%     y = y(validIdx);

    if isempty(x)
        error('No valid data points after removing NaNs.');
    end

    % --- Compute statistics ---
    mu_x = mean(x);
    mu_y = mean(y);
    sigma_x = std(x, 0); % population std
    sigma_y = std(y, 0);

    % Pearson correlation coefficient
    r = corr(x(:), y(:), 'type', 'Pearson');

    % --- Compute CCC ---
    numerator = 2 * r * sigma_x * sigma_y;
    denominator = sigma_x^2 + sigma_y^2 + (mu_x - mu_y)^2;
    ccc = numerator / denominator;
end