/**
 * @title The MORIART ROUND 2 contracts concept.
 * @author www.grox.solutions
 */

pragma solidity 0.5.10;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}

contract MORIART_2 {
    using SafeMath for uint256;

    uint256 constant public ONE_HUNDRED   = 10000;
    uint256 constant public ENTER_FEE     = 1000;
    uint256 constant public FINAL_WAVE    = 1500;
    uint256 constant public ONE_DAY       = 1 days;
    uint256 constant public MINIMUM       = 0.1 ether;
    uint16[5] public refPercent           = [400, 300, 200, 100, 0];
    uint256 public EXIT_FEE_1             = 1000;
    uint256 public EXIT_FEE_2             = 2000;

    uint256 constant public REF_TRIGGER   = 0 ether;
    uint256 constant public REIN_TRIGGER  = 0.00000333 ether;
    uint256 constant public EXIT_TRIGGER  = 0.00000777 ether;

    struct Deposit {
        uint256 amount;
        uint256 time;
    }

    struct User {
        Deposit[] deposits;
        address referrer;
        uint256 bonus;
    }

    mapping (address => User) public users;

    address payable public admin = 0x9C14a7882f635acebbC7f0EfFC0E2b78B9Aa4858;

    uint256 public maxBalance;

    uint256 public start = 1584662400;

    mapping (uint256 => int256) week;
    uint256 period = 7 days;

    bool public finalized;

    event InvestorAdded(address indexed investor);
    event ReferrerAdded(address indexed investor, address indexed referrer);
    event DepositAdded(address indexed investor, uint256 amount);
    event Withdrawn(address indexed investor, uint256 amount);
    event RefBonusAdded(address indexed investor, address indexed referrer, uint256 amount, uint256 indexed level);
    event RefBonusPayed(address indexed investor, uint256 amount);
    event Reinvested(address indexed investor, uint256 amount);
    event Finalized(uint256 amount);
    event GasRefund(uint256 amount);

    modifier notOnPause() {
        require(block.timestamp >= start && !finalized);
        _;
    }

    function() external payable {
        if (msg.value == REF_TRIGGER) {
            withdrawBonus();
        } else if (msg.value == EXIT_TRIGGER) {
            msg.sender.transfer(msg.value);
            exit();
        } else if (msg.value == REIN_TRIGGER) {
            msg.sender.transfer(msg.value);
            reinvest();
        } else {
            invest();
        }
    }

    function invest() public payable notOnPause {
        require(msg.value >= MINIMUM);
        admin.transfer(msg.value * ENTER_FEE / ONE_HUNDRED);

        users[msg.sender].deposits.push(Deposit(msg.value, block.timestamp));

        if (users[msg.sender].referrer != address(0)) {
            _refSystem(msg.sender);
        } else if (msg.data.length == 20) {
            _addReferrer(msg.sender, _bytesToAddress(bytes(msg.data)));
        }

        if (users[msg.sender].deposits.length == 1) {
            emit InvestorAdded(msg.sender);
        }

        if (address(this).balance > maxBalance) {
            maxBalance = address(this).balance;
        }

        week[_getIndex()] += int256(msg.value);

        emit DepositAdded(msg.sender, msg.value);
    }

    function reinvest() public notOnPause {

        uint256 deposit = getDeposits(msg.sender);
        uint256 compensation = 70000 * tx.gasprice;
        uint256 profit = getProfit(msg.sender).add(getRefBonus(msg.sender));
        uint256 amount = profit.sub(compensation);

        delete users[msg.sender].deposits;
        if (users[msg.sender].bonus > 0) {
            users[msg.sender].bonus = 0;
        }

        users[msg.sender].deposits.push(Deposit(deposit + amount, block.timestamp));

        emit Reinvested(msg.sender, amount);

        _refund(compensation);

    }

    function reinvestProfit() public notOnPause {

        uint256 deposit = getDeposits(msg.sender);
        uint256 compensation = 70000 * tx.gasprice;
        uint256 profit = getProfit(msg.sender);
        uint256 amount = profit.sub(compensation);

        delete users[msg.sender].deposits;

        users[msg.sender].deposits.push(Deposit(deposit + amount, block.timestamp));

        emit Reinvested(msg.sender, amount);

        _refund(compensation);

    }

    function reinvestBonus() public notOnPause {

        uint256 compensation = 70000 * tx.gasprice;
        uint256 bonus = getRefBonus(msg.sender);
        uint256 amount = bonus.sub(compensation);

        users[msg.sender].bonus = 0;

        users[msg.sender].deposits.push(Deposit(amount, block.timestamp));

        emit Reinvested(msg.sender, amount);

        _refund(compensation);

    }

    function withdrawBonus() public {
        uint256 payout = getRefBonus(msg.sender);

        require(payout > 0);

        users[msg.sender].bonus = 0;

        bool onFinalizing;
        if (payout > _getFinalWave()) {
            payout = _getFinalWave();
            onFinalizing = true;
        }

        msg.sender.transfer(payout);

        week[_getIndex()] -= int256(payout);

        emit RefBonusPayed(msg.sender, payout);

        if (onFinalizing) {
            _finalize();
        }

    }

    function withdrawProfit() public {
        uint256 payout = getProfit(msg.sender);

        require(payout > 0);

        for (uint256 i = 0; i < users[msg.sender].deposits.length; i++) {
            users[msg.sender].deposits[i].time = block.timestamp;
        }

        bool onFinalizing;
        if (payout > _getFinalWave()) {
            payout = _getFinalWave();
            onFinalizing = true;
        }

        msg.sender.transfer(payout);

        week[_getIndex()] -= int256(payout);

        emit Withdrawn(msg.sender, payout);

        if (onFinalizing) {
            _finalize();
        }

    }

    function exit() public {
        require(block.timestamp >= start + period);

        uint256 deposit = getDeposits(msg.sender);
        uint256 fee = getFee(msg.sender);
        uint256 sum = deposit.add(getProfit(msg.sender)).add(getRefBonus(msg.sender));
        uint256 payout = sum.sub(fee);

        require(payout >= MINIMUM);

        bool onFinalizing;
        if (sum > _getFinalWave()) {
            payout = _getFinalWave();
            onFinalizing = true;
        } else {
            admin.transfer(fee);
        }

        delete users[msg.sender];

        msg.sender.transfer(payout);

        week[_getIndex()] -= int256(payout);

        emit Withdrawn(msg.sender, payout);

        if (onFinalizing) {
            _finalize();
        }
    }

    function setRefPercent(uint16[5] memory newRefPercents) public {
        require(msg.sender == admin);
        for (uint256 i = 0; i < 5; i++) {
            require(newRefPercents[i] <= 1000);
        }
        refPercent = newRefPercents;
    }

    function setExitFee(uint256 fee_1, uint256 fee_2) public {
        require(msg.sender == admin);
        require(fee_1 <= 3000 && fee_2 <= 3000);
        EXIT_FEE_1 = fee_1;
        EXIT_FEE_2 = fee_2;
    }

    function _bytesToAddress(bytes memory source) internal pure returns(address parsedReferrer) {
        assembly {
            parsedReferrer := mload(add(source,0x14))
        }
        return parsedReferrer;
    }

    function _addReferrer(address addr, address refAddr) internal {
        if (refAddr != addr) {
            users[addr].referrer = refAddr;

            _refSystem(addr);
            emit ReferrerAdded(addr, refAddr);
        }
    }

    function _refSystem(address addr) internal {
        address referrer = users[addr].referrer;

        for (uint256 i = 0; i < 5; i++) {
            if (referrer != address(0)) {
                uint256 amount = msg.value * refPercent[i] / ONE_HUNDRED;
                users[referrer].bonus += amount;
                emit RefBonusAdded(addr, referrer, amount, i + 1);
                referrer = users[referrer].referrer;
            } else break;
        }
    }

    function _refund(uint256 amount) internal {
        if (msg.sender.send(amount)) {
            emit GasRefund(amount);
        }
    }

    function _finalize() internal {
        emit Finalized(address(this).balance);
        admin.transfer(address(this).balance);
        finalized = true;
    }

    function _getFinalWave() internal view returns(uint256) {
        if (address(this).balance > maxBalance * FINAL_WAVE / ONE_HUNDRED) {
            return address(this).balance.sub(maxBalance * FINAL_WAVE / ONE_HUNDRED);
        }
    }

    function _getIndex() internal view returns(uint256) {
        if (block.timestamp >= start) {
            return (block.timestamp.sub(start)).div(period);
        }
    }

    function getPercent() public view returns(uint256) {
        if (block.timestamp >= start) {

            uint256 count;
            uint256 idx = _getIndex();

            for (uint256 i = 0; i < idx; i++) {
                if (week[i] >= int256(2 ether * (15**count) / (10**count))) {
                    count++;
                }
            }

            return 50e18 + 10e18 * count + 10e18 * (block.timestamp - (start + period * idx)) / period;
        }
    }

    function getAvailable(address addr) public view returns(uint256) {
        if (users[addr].deposits.length != 0) {
            uint256 deposit = getDeposits(addr);

            uint256 fee = getFee(addr);

            uint256 payout = deposit - fee + getProfit(addr) + getRefBonus(addr);

            return payout;
        }
    }

    function getFee(address addr) public view returns(uint256) {
        if (users[addr].deposits.length != 0) {
            uint256 deposit = getDeposits(addr);

            uint256 fee;
            if (block.timestamp - users[addr].deposits[users[addr].deposits.length - 1].time < 30 * ONE_DAY) {
                fee = deposit * EXIT_FEE_2 / ONE_HUNDRED;
            } else {
                fee = deposit * EXIT_FEE_1 / ONE_HUNDRED;
            }

            return fee;
        }
    }

    function getDeposits(address addr) public view returns(uint256) {
        uint256 sum;

        for (uint256 i = 0; i < users[addr].deposits.length; i++) {
            sum += users[addr].deposits[i].amount;
        }

        return sum;
    }

    function getDeposit(address addr, uint256 index) public view returns(uint256) {
        return users[addr].deposits[index].amount;
    }

    function getProfit(address addr) public view returns(uint256) {
        if (users[addr].deposits.length != 0) {
            uint256 payout;
            uint256 percent = getPercent();

            for (uint256 i = 0; i < users[addr].deposits.length; i++) {
                payout += (users[addr].deposits[i].amount * percent / 1e22) * (block.timestamp - users[addr].deposits[i].time) / ONE_DAY;
            }

            return payout;
        }
    }

    function getRefBonus(address addr) public view returns(uint256) {
        return users[addr].bonus;
    }

    function getNextDate() public view returns(uint256) {
        return(start + ((_getIndex() + 1) * period));
    }

    function getCurrentTurnover() public view returns(int256) {
        return week[_getIndex()];
    }

    function getTurnover(uint256 index) public view returns(int256) {
        return week[index];
    }

    function getCurrentGoal() public view returns(int256) {
        if (block.timestamp >= start) {
            uint256 count;
            uint256 idx = _getIndex();

            for (uint256 i = 0; i < idx; i++) {
                if (week[i] >= int256(2 ether * (15**count) / (10**count))) {
                    count++;
                }
            }

            return int256(2 ether * (15**count) / (10**count));
        }
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

}