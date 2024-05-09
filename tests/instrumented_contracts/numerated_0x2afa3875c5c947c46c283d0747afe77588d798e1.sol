1 pragma solidity 0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to. 
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title ExchangeRate
49  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
50  *
51  * ABI
52  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
53  */
54 contract ExchangeRate is Ownable {
55 
56   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
57 
58   mapping(bytes32 => uint) public rates;
59 
60   /**
61    * @dev Allows the current owner to update a single rate.
62    * @param _symbol The symbol to be updated. 
63    * @param _rate the rate for the symbol. 
64    */
65   function updateRate(string _symbol, uint _rate) public onlyOwner {
66     rates[sha3(_symbol)] = _rate;
67     RateUpdated(now, sha3(_symbol), _rate);
68   }
69 
70   /**
71    * @dev Allows the current owner to update multiple rates.
72    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
73    */
74   function updateRates(uint[] data) public onlyOwner {
75     if (data.length % 2 > 0)
76       throw;
77     uint i = 0;
78     while (i < data.length / 2) {
79       bytes32 symbol = bytes32(data[i * 2]);
80       uint rate = data[i * 2 + 1];
81       rates[symbol] = rate;
82       RateUpdated(now, symbol, rate);
83       i++;
84     }
85   }
86 
87   /**
88    * @dev Allows the anyone to read the current rate.
89    * @param _symbol the symbol to be retrieved. 
90    */
91   function getRate(string _symbol) public constant returns(uint) {
92     return rates[sha3(_symbol)];
93   }
94 
95 }