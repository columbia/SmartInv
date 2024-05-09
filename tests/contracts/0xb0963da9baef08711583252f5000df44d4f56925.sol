pragma solidity 0.4.24;
/*
    Copyright 2018, SECRET 56

    License:
    https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode
*/

library SafeMath {
  function mul(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) pure internal returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) pure internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }

  function abs128(int128 a) internal pure returns (int128) {
    return a < 0 ? a * -1 : a;
  }
}

// Provides basic authorization control, having an owner address
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() internal {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

// Defines only the typical transfer function of ERC20 tokens
contract Token {
    function transfer(address to, uint256 value) public returns (bool);
    function balanceOf(address who) public view returns (uint256);
}

// Can deposit and withdraw ETH and ERC20 tokens
contract Reclaimable is Ownable {

    // Allows payments in the constructor too
    constructor() public payable {
    }

    // Allows payments to this contract
    function() public payable {
    }

    // Withdraw ether from this contract
    function reclaimEther() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    // Withdraws any token with transfer function (ERC20 like)
    function reclaimToken(address _token) public onlyOwner {
        Token token = Token(_token);

        uint256 balance = token.balanceOf(this);
        token.transfer(owner, balance);
    }
}

//////////////////////////////////////////////////////////////
//                                                          //
//                      Storage                             //
//                                                          //
//////////////////////////////////////////////////////////////



contract Storage is Ownable, Reclaimable {
    using SafeMath for uint256;

    uint256 maxGasPrice = 4000000000;
    uint256 public gasrequest = 250000;

    uint256[] public time;
    int256[] public amount;
    address[] public investorsAddresses;

    int256 public aum; 
    uint256 public decimals = 8;
    mapping(uint256 => bool) public timeExists;
    mapping (address => bool) public resellers;
    mapping (address => bool) public investors;
    mapping (address => mapping (address => bool)) resinv;

    mapping(address => uint256) public ntx;
    mapping(address => uint256) public rtx;

    mapping ( address => mapping (uint256 => btcTransaction)) public fundTx;
    mapping ( address => mapping (uint256 => btcTransactionRequest)) public reqWD;

    uint256 public btcPrice;
    uint256 public fee1;
    uint256 public fee2;
    uint256 public fee3;

    // fund deposit address mapping and length
    uint256 public fundDepositAddressesLength;
    mapping (uint256 => string) public fundDepositAddresses;


    uint256 public feeAddressesLength;
    mapping (uint256 => string) public feeAddresses;

    // This can be a deposit or a withdraw transaction
    struct btcTransaction {
        string txId;
        string pubKey;
        string signature;
        // Action here is 0 for deposit and 1 for withdraw
        uint256 action;
        uint256 timestamp;
    }

    // This is only a request of a transaction
 
    struct btcTransactionRequest {
        string txId;
        string pubKey;
        string signature;
        uint256 action; // Is action needed here???
        uint256 timestamp;
        string referal;
    }

	constructor () public {

	}
    /** SET FUND BTC ADDRESS */

    function setfundDepositAddress(string bitcoinAddress) public onlyOwner {
        // Add bitcoin address to index and increment index
        fundDepositAddresses[fundDepositAddressesLength++] = bitcoinAddress;
    }

    function setFeeAddress(string bitcoinAddress) public onlyOwner {
        // Add bitcoin address to index and increment index
        feeAddresses[feeAddressesLength++] = bitcoinAddress;
    }

    /** DEPOSITS */

    function setRequestGas (uint256 _gasrequest) public onlyOwner{
        gasrequest = _gasrequest;
    }

    function setAum(int256 _aum) public onlyOwner{
        aum = _aum;
    }


    function depositAdmin(address addr,string txid, string pubkey, string signature) public onlyOwner{
        setInvestor(addr, true);
        addTX (addr,txid, pubkey, signature, 0); 
    
        uint256 gasPrice = tx.gasprice;
        uint256 repayal = gasPrice.mul(gasrequest);
        addr.transfer(repayal);
    }

    /** WITHDRAWS */

    // FIXME: bad naming, request with T
    function requesWithdraw(address addr,string txid, string pubkey, string signature, string referal) public {
        require(investors[msg.sender]==true);

        uint256 i =  rtx[addr];
        reqWD[addr][i].txId=txid;
        reqWD[addr][i].pubKey=pubkey;
        reqWD[addr][i].signature=signature;
        reqWD[addr][i].action=1;
        reqWD[addr][i].timestamp = block.timestamp;
        reqWD[addr][i].referal = referal;
        ++rtx[addr];
    }

    function returnInvestment(address addr,string txid, string pubkey, string signature) public onlyOwner {
        // FIXME: Should check if its not returned already!!
        addTX (addr,txid, pubkey, signature, 1);
    }

    /** INVESTORS */

    function setInvestor(address _addr, bool _allowed) public onlyOwner {
        investors[_addr] = _allowed;
        if(_allowed != false){
            uint256 hasTransactions= ntx[_addr];
            if(hasTransactions == 0){
                investorsAddresses.push(_addr);
            }
        }
    }

    function getAllInvestors() public view returns (address[]){
        return investorsAddresses;
    }

    /** RESELLER FUNCTIONALITY? */

    function setReseller(address _addr, bool _allowed) public onlyOwner {
        resellers[_addr] = _allowed;
    }

    function setResellerInvestor(address _res, address _inv, bool _allowed) public onlyOwner {
        resinv[_res][_inv] = _allowed;
    }

    /** UTILITIES */

    // Adds a new tx even if it exists already
    function addTX (address addr,string txid, string pubkey, string signature, uint256 action) internal {
        uint256 i =  ntx[addr];
        fundTx[addr][i].txId = txid;
        fundTx[addr][i].pubKey = pubkey;
        fundTx[addr][i].signature = signature;
        fundTx[addr][i].action = action;
        fundTx[addr][i].timestamp = block.timestamp;
        ++ntx[addr];
    }

    function getTx (address addr, uint256 i) public view returns (string,string,string,uint256, uint256) {
        return (fundTx[addr][i].txId,fundTx[addr][i].pubKey,fundTx[addr][i].signature,fundTx[addr][i].action, fundTx[addr][i].timestamp);
    }

    function setData(uint256 t, int256 a) public onlyOwner{
        require(timeExists[t] != true);
        time.push(t);
        amount.push(a);
        timeExists[t] = true;
    }

    function setDataBlock(int256 a) public onlyOwner{
        require(timeExists[block.timestamp] != true);
        time.push(block.timestamp);
        amount.push(a);
        timeExists[block.timestamp] = true;
    }

    function getAll() public view returns(uint256[] t, int256[] a){
        return (time, amount);
    }

    function setBtcPrice(uint256 _price) public onlyOwner {
        btcPrice = _price;
    }

    
    function setFee(uint256 _fee1,uint256 _fee2,uint256 _fee3) public onlyOwner {
        fee1 = _fee1;
        fee2 = _fee2;
        fee3 = _fee3;
    }
}