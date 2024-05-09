pragma solidity 0.5.11;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
}

interface ICustomersFundable {
    function fundCustomer(address customerAddress, uint256 value, uint8 subconto) external payable;
}

interface IRemoteWallet {
    function invest(address customerAddress, address target, uint256 value, uint8 subconto) external returns (bool);
}

interface IUSDT {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external;
    function decimals() external view returns(uint8);
}

contract NTSCD {
    using SafeMath for uint256;

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    modifier onlyBoss3 {
        require(msg.sender == boss3);
        _;
    }

    string public name = "NTS Crypto Deposit";
    string public symbol = "NTSCD";
    uint8 constant public decimals = 18;

    address public admin;
    address constant internal boss1 = 0xCa27fF938C760391E76b7aDa887288caF9BF6Ada;
    address constant internal boss2 = 0xf43414ABb5a05c3037910506571e4333E16a4bf4;
    address public boss3 = 0x2Cf6A513b20863C8EEB56bBCda806F69605b7c1A;

    uint256 public refLevel1_ = 9;
    uint256 public refLevel2_ = 3;
    uint256 public refLevel3_ = 2;

    uint256 internal tokenPrice = 1;
    uint256 public minimalInvestment = 500e6;
    uint256 public stakingRequirement = 0;

    mapping(address => uint256) internal tokenBalanceLedger_;
    mapping(address => uint256) public referralBalance_;
    mapping(address => uint256) public repayBalance_;
    mapping(address => uint256) public mayPassRepay_;

    uint256 internal tokenSupply_;
    bool public saleOpen = true;

    address private refBase = address(0x0);

    IUSDT public token;

    constructor(address tokenAddr, address recipient, uint256 initialSupply) public {
        token = IUSDT(tokenAddr);

        admin = msg.sender;
        mayPassRepay_[boss1] = 1e60;
        mayPassRepay_[boss2] = 1e60;
        mayPassRepay_[boss3] = 1e60;

        tokenBalanceLedger_[recipient] = initialSupply;
        tokenSupply_ = initialSupply;
        emit Transfer(address(0), recipient, initialSupply);
    }

    function buy(uint256 value, address _ref1, address _ref2, address _ref3) public returns (uint256) {
        require(value >= minimalInvestment, "Value is below minimal investment.");
        require(token.allowance(msg.sender, address(this)) >= value, "Token allowance error: approve this amount first");
        require(saleOpen, "Sales stopped for the moment.");
        token.transferFrom(msg.sender, address(this), value);
        return purchaseTokens(value, _ref1, _ref2, _ref3);
    }

    function reinvest() public {
        address _customerAddress = msg.sender;
        uint256 value = referralBalance_[_customerAddress];
        require(value > 0);

        referralBalance_[_customerAddress] = 0;
        uint256 _tokens = purchaseTokens(value, address(0x0), address(0x0), address(0x0));
        emit OnReinvestment(_customerAddress, value, _tokens, false, now);
    }

    function exit() public {
        address _customerAddress = msg.sender;
        uint256 balance = repayBalance_[_customerAddress];
        if (balance > 0) getRepay();
        withdraw();
    }

    function withdraw() public {
        address _customerAddress = msg.sender;
        uint256 value = referralBalance_[_customerAddress];
        require(value > 0);
        referralBalance_[_customerAddress] = 0;
        token.transfer(_customerAddress, value);
        emit OnWithdraw(_customerAddress, value, now);
    }

    function getRepay() public {
        address _customerAddress = msg.sender;
        uint256 balance = repayBalance_[_customerAddress];
        require(balance > 0, "Sender has nothing to repay");
        repayBalance_[_customerAddress] = 0;
        uint256 tokens = tokenBalanceLedger_[_customerAddress];
        tokenBalanceLedger_[_customerAddress] = 0;
        tokenSupply_ = tokenSupply_.sub(tokens);

        token.transfer(_customerAddress, balance);
        emit OnGotRepay(_customerAddress, balance, now);
        emit Transfer(_customerAddress, address(0), tokens);
    }

    function balanceOf(address _customerAddress) public view returns (uint256) {
        return tokenBalanceLedger_[_customerAddress];
    }

    function purchaseTokens(uint256 _incomingValue, address _ref1, address _ref2, address _ref3) internal returns (uint256) {
        address _customerAddress = msg.sender;
        uint256 welcomeFee_ = refLevel1_.add(refLevel2_).add(refLevel3_);
        require(welcomeFee_ <= 99);

        uint256[7] memory uIntValues = [
            _incomingValue.mul(welcomeFee_).div(100),
            0,
            0,
            0,
            0,
            0,
            0
        ];

        uIntValues[1] = uIntValues[0].mul(refLevel1_).div(welcomeFee_);
        uIntValues[2] = uIntValues[0].mul(refLevel2_).div(welcomeFee_);
        uIntValues[3] = uIntValues[0].mul(refLevel3_).div(welcomeFee_);

        uint256 _taxedValue = _incomingValue.sub(uIntValues[0]);

        uint256 _amountOfTokens = valueToTokens_(_incomingValue);

        require(_amountOfTokens > 0);

        if (
            _ref1 != 0x0000000000000000000000000000000000000000 &&
            tokensToValue_(tokenBalanceLedger_[_ref1]) >= stakingRequirement
        ) {
            if (refBase == address(0x0)) {
                referralBalance_[_ref1] = referralBalance_[_ref1].add(uIntValues[1]);
            } else {
                uint256 allowed = token.allowance(address(this), refBase);
                if (allowed != 0) {
                    token.approve(refBase, 0);
                }
                token.approve(refBase, allowed + uIntValues[1]);
                ICustomersFundable(refBase).fundCustomer(_ref1, uIntValues[1], 1);
                uIntValues[4] = uIntValues[1];
            }
        } else {
            referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[1]);
            _ref1 = 0x0000000000000000000000000000000000000000;
        }

        if (
            _ref2 != 0x0000000000000000000000000000000000000000 &&
            tokensToValue_(tokenBalanceLedger_[_ref2]) >= stakingRequirement
        ) {
            if (refBase == address(0x0)) {
                referralBalance_[_ref2] = referralBalance_[_ref2].add(uIntValues[2]);
            } else {
                uint256 allowed = token.allowance(address(this), refBase);
                if (allowed != 0) {
                    token.approve(refBase, 0);
                }
                token.approve(refBase, allowed + uIntValues[2]);
                ICustomersFundable(refBase).fundCustomer(_ref2, uIntValues[2], 2);
                uIntValues[5] = uIntValues[2];
            }
        } else {
            referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[2]);
            _ref2 = 0x0000000000000000000000000000000000000000;
        }

        if (
            _ref3 != 0x0000000000000000000000000000000000000000 &&
            tokensToValue_(tokenBalanceLedger_[_ref3]) >= stakingRequirement
        ) {
            if (refBase == address(0x0)) {
                referralBalance_[_ref3] = referralBalance_[_ref3].add(uIntValues[3]);
            } else {
                uint256 allowed = token.allowance(address(this), refBase);
                if (allowed != 0) {
                    token.approve(refBase, 0);
                }
                token.approve(refBase, allowed + uIntValues[3]);
                ICustomersFundable(refBase).fundCustomer(_ref3, uIntValues[3], 3);
                uIntValues[6] = uIntValues[3];
            }
        } else {
            referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[3]);
            _ref3 = 0x0000000000000000000000000000000000000000;
        }

        referralBalance_[boss2] = referralBalance_[boss2].add(_taxedValue);

        tokenSupply_ = tokenSupply_.add(_amountOfTokens);

        tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].add(_amountOfTokens);

        emit OnTokenPurchase(_customerAddress, _incomingValue, _amountOfTokens, _ref1, _ref2, _ref3, uIntValues[4], uIntValues[5], uIntValues[6], now);
        emit Transfer(address(0), _customerAddress, _amountOfTokens);

        return _amountOfTokens;
    }

    function valueToTokens_(uint256 _value) public view returns (uint256) {
        uint256 _tokensReceived = _value.mul(tokenPrice).mul(1e12);

        return _tokensReceived;
    }

    function tokensToValue_(uint256 _tokens) public view returns (uint256) {
        uint256 _valueReceived = _tokens.div(tokenPrice).div(1e12);

        return _valueReceived;
    }

    /* Admin methods */
    function mint(address customerAddress, uint256 value) public onlyBoss3 {
        tokenSupply_ = tokenSupply_.add(value);
        tokenBalanceLedger_[customerAddress] = tokenBalanceLedger_[customerAddress].add(value);

        emit OnMint(customerAddress, value, now);
        emit Transfer(address(0), customerAddress, value);
    }

    function setRefBonus(uint8 level1, uint8 level2, uint8 level3, uint256 minInvest, uint256 staking) public {
        require(msg.sender == boss3 || msg.sender == admin);
        refLevel1_ = level1;
        refLevel2_ = level2;
        refLevel3_ = level3;

        minimalInvestment = minInvest;
        stakingRequirement = staking;

        emit OnRefBonusSet(level1, level2, level3, minInvest, staking, now);
    }

    function passRepay(uint256 value, address customerAddress, string memory comment) public {
        require(mayPassRepay_[msg.sender] > 0, "Not allowed to pass repay from your address.");
        require(value > 0);
        require(value <= mayPassRepay_[msg.sender], "Sender is not allowed");
        require(value <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");

        token.transferFrom(msg.sender, address(this), value);

        mayPassRepay_[msg.sender] = mayPassRepay_[msg.sender].sub(value);

        repayBalance_[customerAddress] = repayBalance_[customerAddress].add(value);
        emit OnRepayPassed(customerAddress, msg.sender, value, comment, now);
    }

    function allowPassRepay(address payer, uint256 value, string memory comment) public onlyAdmin {
        mayPassRepay_[payer] = value;
        emit OnRepayAddressAdded(payer, value, comment, now);
    }

    function passInterest(uint256 value, address customerAddress, uint256 valueRate, uint256 rate, string memory comment) public {
        require(mayPassRepay_[msg.sender] > 0, "Not allowed to pass interest from your address");
        require(value > 0);
        require(value <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");

        token.transferFrom(msg.sender, address(this), value);

        if (refBase == address(0x0)) {
            referralBalance_[customerAddress] = referralBalance_[customerAddress].add(value);
        } else {
            uint256 allowed = token.allowance(address(this), refBase);
            if (allowed != 0) {
                token.approve(refBase, 0);
            }
            token.approve(refBase, allowed + value);
            ICustomersFundable(refBase).fundCustomer(customerAddress, value, 5);
        }

        emit OnInterestPassed(customerAddress, value, valueRate, rate, comment, now);
    }

    function switchState() public onlyAdmin {
        if (saleOpen) {
            saleOpen = false;
            emit OnSaleStop(now);
        } else {
            saleOpen = true;
            emit OnSaleStart(now);
        }
    }

    function deposeBoss3(address x) public onlyAdmin {
        emit OnBoss3Deposed(boss3, x, now);
        boss3 = x;
    }

    function setRefBase(address x) public onlyAdmin {
        emit OnRefBaseSet(refBase, x, now);
        refBase = x;
    }

    function seize(address customerAddress, address receiver) public {
        require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);

        uint256 tokens = tokenBalanceLedger_[customerAddress];
        if (tokens > 0) {
            tokenBalanceLedger_[customerAddress] = 0;
            tokenBalanceLedger_[receiver] = tokenBalanceLedger_[receiver].add(tokens);
            emit Transfer(customerAddress, receiver, tokens);
        }

        uint256 value = referralBalance_[customerAddress];
        if (value > 0) {
            referralBalance_[customerAddress] = 0;
            referralBalance_[receiver] = referralBalance_[receiver].add(value);
        }

        uint256 repay = repayBalance_[customerAddress];
        if (repay > 0) {
            repayBalance_[customerAddress] = 0;
            referralBalance_[receiver] = referralBalance_[receiver].add(repay);
        }

        emit OnSeize(customerAddress, receiver, tokens, value, repay, now);
    }

    function setName(string memory newName, string memory newSymbol) public {
        require(msg.sender == admin || msg.sender == boss1);

        emit OnNameSet(name, symbol, newName, newSymbol, now);
        name = newName;
        symbol = newSymbol;
    }

    function shift(address holder, address recipient, uint256 value) public {
        require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
        require(value > 0);

        tokenBalanceLedger_[holder] = tokenBalanceLedger_[holder].sub(value);
        tokenBalanceLedger_[recipient] = tokenBalanceLedger_[recipient].add(value);

        emit OnShift(holder, recipient, value, now);
        emit Transfer(holder, recipient, value);
    }

    function burn(address holder, uint256 value) public {
        require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);
        require(value > 0);

        tokenSupply_ = tokenSupply_.sub(value);
        tokenBalanceLedger_[holder] = tokenBalanceLedger_[holder].sub(value);

        emit OnBurn(holder, value, now);
        emit Transfer(holder, address(0), value);
    }

    function withdrawERC20(address ERC20Token, address recipient, uint256 value) public {
        require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);

        require(value > 0);

        IUSDT(ERC20Token).transfer(recipient, value);
    }

    event OnTokenPurchase(
        address indexed customerAddress,
        uint256 incomingValue,
        uint256 tokensMinted,
        address ref1,
        address ref2,
        address ref3,
        uint256 ref1value,
        uint256 ref2value,
        uint256 ref3value,
        uint256 timestamp
    );

    event OnReinvestment(
        address indexed customerAddress,
        uint256 valueReinvested,
        uint256 tokensMinted,
        bool isRemote,
        uint256 timestamp
    );

    event OnWithdraw(
        address indexed customerAddress,
        uint256 value,
        uint256 timestamp
    );

    event OnGotRepay(
        address indexed customerAddress,
        uint256 value,
        uint256 timestamp
    );

    event OnRepayPassed(
        address indexed customerAddress,
        address indexed payer,
        uint256 value,
        string comment,
        uint256 timestamp
    );

    event OnInterestPassed(
        address indexed customerAddress,
        uint256 value,
        uint256 valueRate,
        uint256 rate,
        string comment,
        uint256 timestamp
    );

    event OnSaleStop(
        uint256 timestamp
    );

    event OnSaleStart(
        uint256 timestamp
    );

    event OnRepayAddressAdded(
        address indexed payer,
        uint256 value,
        string comment,
        uint256 timestamp
    );

    event OnRepayAddressRemoved(
        address indexed payer,
        uint256 timestamp
    );

    event OnMint(
        address indexed customerAddress,
        uint256 value,
        uint256 timestamp
    );

    event OnBoss3Deposed(
        address indexed former,
        address indexed current,
        uint256 timestamp
    );

    event OnRefBonusSet(
        uint8 level1,
        uint8 level2,
        uint8 level3,
        uint256 minimalInvestment,
        uint256 stakingRequirement,
        uint256 timestamp
    );

    event OnRefBaseSet(
        address indexed former,
        address indexed current,
        uint256 timestamp
    );

    event OnSeize(
        address indexed customerAddress,
        address indexed receiver,
        uint256 tokens,
        uint256 value,
        uint256 repayValue,
        uint256 timestamp
    );

    event OnFund(
        address indexed source,
        uint256 value,
        uint256 timestamp
    );

    event OnBurn (
        address holder,
        uint256 value,
        uint256 timestamp
    );

    event OnShift (
        address holder,
        address recipient,
        uint256 value,
        uint256 timestamp
    );

    event OnNameSet (
        string oldName,
        string oldSymbol,
        string newName,
        string newSymbol,
        uint256 timestamp
    );

    event OnTokenSet (
        address oldToken,
        address newToken,
        uint256 timestamp
    );

    event Transfer (
        address indexed from,
        address indexed to,
        uint256 value
    );
}