1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control 
4  * functions, this simplifies the implementation of "user permissions". 
5  */
6 contract Ownable {
7   address public owner;
8 
9   /** 
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev Throws if called by any account other than the owner. 
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to. 
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 
38 /**
39  * @title ExchangeRate
40  * @dev Allows updating and retrieveing of Conversion Rates for ABLE tokens
41  *
42  * ABI
43  * [{"constant": false,"inputs": [{"name": "_symbol","type": "string"},{"name": "_rate","type": "uint256"}],"name": "updateRate","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "data","type": "uint256[]"}],"name": "updateRates","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_symbol","type": "string"}],"name": "getRate","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "","type": "bytes32"}],"name": "rates","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": false,"name": "timestamp","type": "uint256"},{"indexed": false,"name": "symbol","type": "bytes32"},{"indexed": false,"name": "rate","type": "uint256"}],"name": "RateUpdated","type": "event"}]
44  */
45 contract ExchangeRate is Ownable {
46 
47   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
48 
49   mapping(bytes32 => uint) public rates;
50 
51   /**
52    * @dev Allows the current owner to update a single rate.
53    * @param _symbol The symbol to be updated. 
54    * @param _rate the rate for the symbol. 
55    */
56   function updateRate(string _symbol, uint _rate) public onlyOwner {
57     rates[sha3(_symbol)] = _rate;
58     RateUpdated(now, sha3(_symbol), _rate);
59   }
60 
61   /**
62    * @dev Allows the current owner to update multiple rates.
63    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
64    */
65   function updateRates(uint[] data) public onlyOwner {
66     require(data.length % 2 == 0);
67     uint i = 0;
68     while (i < data.length / 2) {
69       bytes32 symbol = bytes32(data[i * 2]);
70       uint rate = data[i * 2 + 1];
71       rates[symbol] = rate;
72       RateUpdated(now, symbol, rate);
73       i++;
74     }
75   }
76 
77   /**
78    * @dev Allows the anyone to read the current rate.
79    * @param _symbol the symbol to be retrieved. 
80    */
81   function getRate(string _symbol) public constant returns(uint) {
82     return rates[sha3(_symbol)];
83   }
84 
85 }