1 pragma solidity ^0.4.24;
2 
3 contract TokenContract {
4   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7 }
8 
9 contract Ownable {
10   address public owner;
11 
12   constructor() public {
13     owner = msg.sender;
14   }
15   
16   modifier onlyOwner() {
17     require(msg.sender == owner, "Only Owner");
18     _;
19   }
20 }
21 
22 contract GymRewardsExchange is Ownable {
23   TokenContract public tkn;
24   bool public active = true;
25   mapping (address => uint256) public deposits;
26   mapping (address => string) public ethtoeosAddress;
27   mapping (bytes32 => address) public eostoethAddress;
28   mapping (uint256 => address) public indexedAddress;
29   uint256 public addresIndex = 0;
30 
31   constructor() public {
32     tkn = TokenContract(0x92D3e963aA94D909869940A8d15FA16CcbC6655E);
33   }
34 
35   function activateExchange(bool _active) public onlyOwner {
36     active = _active;
37   }
38 
39   function deposit(bytes32 _addressHash, string _eosAddress) public {
40     require(active, "Exchange is not active");
41     uint256 currentBalance = tkn.balanceOf(msg.sender);
42     require(currentBalance > 0, "You should have Tokens to exchange");
43     require(tkn.allowance(msg.sender, address(this)) == currentBalance, "This contract needs aproval for the whole amount of tokens");
44     require(deposits[msg.sender] == 0, "Only one deposit per address is allowed");
45     if (tkn.transferFrom(msg.sender, address(this), currentBalance)) {
46       addresIndex += 1;
47       indexedAddress[addresIndex] = msg.sender;
48       deposits[msg.sender] = currentBalance;
49       ethtoeosAddress[msg.sender] = _eosAddress;
50       eostoethAddress[_addressHash] = msg.sender;
51       emit NewDeposit(msg.sender, currentBalance, _eosAddress);
52     }
53   }
54 
55   function checkAddressDeposit(address _address) public view returns (uint256) {
56       return(deposits[_address]);
57   }
58   
59   function checkAddressEOS(address _address) public view returns (string) {
60       return(ethtoeosAddress[_address]);
61   }
62 
63   function checkAddressETH(bytes32 _address) public view returns (address) {
64       return(eostoethAddress[_address]);
65   }
66   
67   event NewDeposit(address senderAccount, uint256 amount, string eosAddress);
68 
69 }