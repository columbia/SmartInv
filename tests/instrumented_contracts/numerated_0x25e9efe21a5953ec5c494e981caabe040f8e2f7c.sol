1 pragma solidity 0.4.23;
2 
3 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/ExchangeRate.sol
46 
47 /// @title  ExchangeRate
48 /// @author Jose Perez - <jose.perez@diginex.com>
49 /// @notice Tamper-proof record of exchange rates e.g. BTC/USD, ETC/USD, etc.
50 /// @dev    Exchange rates are updated from off-chain server periodically. Rates are taken from a
51 //          publicly available third-party provider, such as Coinbase, CoinMarketCap, etc.
52 contract ExchangeRate is Ownable {
53     event RateUpdated(string id, uint256 rate);
54     event UpdaterTransferred(address indexed previousUpdater, address indexed newUpdater);
55 
56     address public updater;
57 
58     mapping(string => uint256) internal currentRates;
59 
60     /// @dev The ExchangeRate constructor.
61     /// @param _updater Account which can update the rates.
62     constructor(address _updater) public {
63         require(_updater != address(0));
64         updater = _updater;
65     }
66 
67     /// @dev Throws if called by any account other than the updater.
68     modifier onlyUpdater() {
69         require(msg.sender == updater);
70         _;
71     }
72 
73     /// @dev Allows the current owner to change the updater.
74     /// @param _newUpdater The address of the new updater.
75     function transferUpdater(address _newUpdater) external onlyOwner {
76         require(_newUpdater != address(0));
77         emit UpdaterTransferred(updater, _newUpdater);
78         updater = _newUpdater;
79     }
80 
81     /// @dev Allows the current updater account to update a single rate.
82     /// @param _id The rate identifier.
83     /// @param _rate The exchange rate.
84     function updateRate(string _id, uint256 _rate) external onlyUpdater {
85         require(_rate != 0);
86         currentRates[_id] = _rate;
87         emit RateUpdated(_id, _rate);
88     }
89 
90     /// @dev Allows anyone to read the current rate.
91     /// @param _id The rate identifier.
92     /// @return The current rate.
93     function getRate(string _id) external view returns(uint256) {
94         return currentRates[_id];
95     }
96 }