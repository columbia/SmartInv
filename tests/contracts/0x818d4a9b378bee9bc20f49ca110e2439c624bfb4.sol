/* 

NETWORK SMART CONTRACT
https://joinnet.work

Powered by PROOF CAPITAL GROUP
Developed by @cryptocreater
Audited by Techrate.Org

 ########################################
 ########################################
 ### ATTENTION!                       ###
 ### To avoid OUT OF GAS error, make  ###
 ### sure that fee GAS limit make at  ###
 ### least 250'000 GAS!               ###
 ### The amount of GAS is indicated   ###
 ### with a margin, in fact, the      ###
 ### transaction fee should be less,  ###
 ### up to 80'000 GAS.                ###
 ########################################
 ########################################

BASIC CONDITIONS.
1.  The Network smart contract does not have a beneficiary or other affiliated persons receiving an individual reward over standart Network marketing.
2.  You can exchange Ethereum (ETH) for Network tokens (NET) only after receiving a registration transfer from the address previously registered on the Network smart contract.
3.  The linking of the subscriber (referral) address is carried out by transferring to it any number of NET, provided that no one has done this yet, and the referral link cannot be changed under any circumstances, except for the situation described in p.4.
4.  Important! If at the time of accrual of the referral reward the balance of the address is less than 0.0625 NET, the referrer address of the referral chain lower address will be replaced with the address of a higher referral chain address. In other words, the subordinate address will be moved to upstream address in the referral chain. This action is irreversible and affects only the referral chain and the associated marketing conditions of the Network smart contract.
5.  The exchange of NET for ETH is carried out by making an ETH deposit to the Network smart contract address and NET issuing.
6.  The minimum exchange amount is 1 GWEI (0.000000001 ETH).
7.  The exchange rate of NET for ETH at the time of exchange is calculated by the formula:
        R = E / S
        where
        R - exchange rate NET for ETH;
        E - the total amount of ETH deposit placed on the balance of the Network smart contract;
        S - the total emission of NET.
8.  At the time of depositing (exchanging) ETH for the Network smart contract, the current rate is calculated and 70% of the received amount is NET issued to the address from which ETH deposit was placed (transferred), and the remaining amount is distributed according to the referral chain ten levels up, starting from 15% for the address of the first level and further with a decrease in the amount of issue and accrual of NET by half at each next level.
9.  To receive a reward from the referral chain, the address balance must have at least 0.0625 NET to receive rewards from the first lower level with a doubling for each subsequent level in depth to the tenth level. Thus, in order to receive a reward from 10 levels, the address must have at least 32 NET. The amount of the referral reward received depends on the balance of the address at the time of calculation. If the balance of the address is greater than or equal to the total potential amount of NET issue according to the placed ETH deposit, the full amount of remuneration is accrued according to the Network marketing, otherwise the remuneration is calculated using the formula:
        R = B / D * E
        where
        R - received remuneration;
        B - address balance;
        D - amount of potentially issued NET per placed ETH deposit;
        E - total amount of remuneration by level according to Network Marketing.
10.  For the missed or reduced reward, NET are not issued, thereby increasing the ratio of the total amount of ETH deposit to the total number of NET.
12.  The reverse exchange (return) of the deposit is carried out by transferring NET to the address of the Network smart contract, while ETH deposit will be returned to the address that sent the tokens at the rate according to the formula specified in p.7.
13.  NET tokens received at the address of the smart contract are destroyed, thereby providing a positive growth trend in the exchange rate of NET for ETH, except for the situation described in p.14.
14.  From the launch of Network smart contract until the total emission of 50 NET is reached, the exchange rate is fixed at 1 NET = 1 ETH by issuing the missed and unreceived reward on the balance of the Network smart contract. When the total token emission of 50 NET is reached, all NET on the balance of the smart contract are destroyed (burned) and a dynamic token exchange rate is established.
15.  Any address that is the only address with a positive NET balance can reset it's balance, the balance of Network smart contract, withdraw all deposited ETH on the smart contract by using RESTART function. In this case, the exchange rate will return to 1:1 and will be fixed until the emission of 50 NET is reached.
17.  For ease of use, the RATE function of smart contract displays the exchange rate of 1 NET for 1 ETH multiplied by 1'000'000 due to the lack of the ability to display floating point numbers in the Ethereum EVM, is for informational purposes only and is not used in calculating actual values within the smart contract marketing and functionality.
18.  NET supports all the generally accepted functions and properties of the ERC20 standard on the Ethereum blockchain, incl. transfers, storage and decentralized applications.

(c) 2020 PROOF CAPITAL GROUP

*/

pragma solidity 0.6.6;
interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
contract ERC20 is IERC20 {
    event CheckOut(address indexed account, uint256 ethers);
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name = "Network";
    string private _symbol = "NET";
    uint8 private _decimals = 18;
    function safeAdd(uint256 a, uint256 b) private pure returns (uint256) {
    	require(a + b > a, "Addition overflow");
    	return a + b;
    }
    function safeSub(uint256 a, uint256 b) private pure returns (uint256) {
    	require(a >= b, "Substruction overflow");
    	return a - b;
    }
    function name() public view returns (string memory) {
        return _name;
    }    
    function symbol() public view returns (string memory) {
        return _symbol;
    }    
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, safeSub(_allowances[sender][msg.sender], amount));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        require(addedValue > 0, "Zero amount");
        _approve(msg.sender, spender, safeAdd(_allowances[msg.sender][spender], addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        require(_allowances[msg.sender][spender] >= subtractedValue, "Exceed amount");
        _approve(msg.sender, spender, safeSub(_allowances[msg.sender][spender], subtractedValue));
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(amount > 0, "Zero amount");
        require(sender != address(0), "Zero sender");
        require(recipient != address(0), "Zero recipient");
        uint256 _value = tokenTransfer(sender, recipient, amount);
        if(_value > 0) {
            _balances[sender] = safeSub(_balances[sender], amount);
            _totalSupply = safeSub(_totalSupply, amount);
            emit CheckOut(sender, _value);
            emit Transfer(sender, address(0), amount);
            payable(sender).transfer(_value);
        } else {
        	_balances[sender] = safeSub(_balances[sender], amount);
            _balances[recipient] = safeAdd(_balances[recipient], amount);
            emit Transfer(sender, recipient, amount);
        }
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(amount > 0, "Zero amount");
        require(account != address(0), "Zero TO address");
        _totalSupply = safeAdd(_totalSupply, amount);
        _balances[account] = safeAdd(_balances[account], amount);
        emit Transfer(address(0), account, amount);
    }
    function _charge(address account, uint256 amount, bool charge) internal virtual {
        if(charge) {
        	_balances[account] = safeAdd(_balances[account], amount);
            emit Transfer(address(0), account, amount);
        } else {
        	_totalSupply = safeAdd(_totalSupply, amount);
        }
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(amount > 0, "Zero amount");
        require(account != address(0), "Zero acount");
        _balances[account] = safeSub(_balances[account], amount);
        _totalSupply = safeSub(_totalSupply, amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Zero owner");
        require(spender != address(0), "Zero spender");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function tokenTransfer(address from, address to, uint256 amount) internal virtual returns (uint256) { }
}
contract Network is ERC20 {
    event CheckIn(address indexed account, uint256 ethers);
    event Missed(address indexed account, uint8 level, uint256 tokens);
    event Compression(address indexed account, address indexed previous, address indexed current);
    event Restart(address indexed account, uint256 tokens, uint256 ethers);
    event RateUp(uint32 timestamp, uint256 rate);
    address private smart;
    mapping(address => address) public referrers;
    uint128 public raisup = 5 * 1e19;
    constructor() public {
        smart = address(this);
        referrers[msg.sender] = smart;
        referrers[smart] = smart;
    }
    function tokenTransfer(address _from, address _to, uint256 _amount) internal override returns (uint256) {
        if(_to == smart) {
            return _amount * smart.balance / totalSupply();
        } else {
            if(referrers[_to] == address(0)) referrers[_to] = _from;
            return 0;
        }
    }
    receive() payable external {
        require(referrers[msg.sender] != address(0), "Zero referrer");
        require(msg.value >= 1e9, "Little amount");
        uint256 _cap = smart.balance - msg.value;
        uint256 _payout = _cap > 0 ? msg.value * totalSupply() / _cap : msg.value;
        reward(msg.sender, referrers[msg.sender], _payout);
    }
    function reward(address _account, address _referrer, uint256 _payout) private {
        uint128 _minimum = 625 * 1e14;
        uint256 _charged;
        uint256 _purchase = _payout * 7 / 10;
        uint256 _profit = _payout - _purchase;
        uint256 _reward = _profit / 2;
        emit CheckIn(msg.sender, msg.value);
        _mint(msg.sender, _purchase);
        for(uint8 _level = 1; _level < 11; _level++) {
            if(_referrer != smart) {
                uint256 _balance = balanceOf(_referrer);
                if(_balance >= _minimum) {
                    _account = _referrer;
                    uint256 _reward_ = _balance > _payout ? _reward : _reward * _balance / _payout;
                    _profit -= _reward_;
                    _charged += _reward_;
                    _charge(_referrer, _reward_, true);
                    if(_reward > _reward_) emit Missed(_referrer, _level,  _reward - _reward_);
                } else {
                    if(_balance < 625 * 1e14) {
                        address _upreferrer = referrers[_referrer];
                        if(_upreferrer != smart) {
                            emit Compression(_account, referrers[_account], _upreferrer);
                            referrers[_account] = _upreferrer;
                        }
                    } else {
                        _account = _referrer;
                        emit Missed(_referrer, _level, _reward);
                    }
                }
            } else {
                _level = 11;
            }
            _referrer = referrers[_referrer];
            _reward /= 2;
            _minimum *= 2;
        }
        if(_charged > 0) _charge(address(0), _charged, false);
        if(raisup > 0) {
            if(_profit > 0) _mint(smart, _profit);
            if(totalSupply() >= raisup) {
                raisup = 0;
                _burn(smart, balanceOf(smart));
            }
        } else {
            emit RateUp(uint32(block.timestamp), this.rate());
        }
    }
    function restart() external {
        require(balanceOf(msg.sender) + balanceOf(smart) == totalSupply(), "Not alone");
        if(balanceOf(msg.sender) > 0) _burn(msg.sender, balanceOf(msg.sender));
        if(balanceOf(smart) > 0) _burn(smart, balanceOf(smart));
        raisup = 5 * 1e19;
        emit Restart(msg.sender, balanceOf(msg.sender) + balanceOf(smart), smart.balance);
        payable(msg.sender).transfer(smart.balance);
    }
    function burn(uint256 _value) external {
        _burn(msg.sender, _value);
    }
    function rate() external view returns (uint256) {
        return totalSupply() > 0 && smart.balance > 0 ? smart.balance * 1e6 / totalSupply() : 1e6; 
    }
    function cap() external view returns (uint256) {
        return smart.balance > 0 ? smart.balance : 0;
    }
}