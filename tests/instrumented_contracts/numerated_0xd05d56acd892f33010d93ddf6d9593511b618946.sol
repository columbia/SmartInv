1 contract DgxToken {
2   function approve(address _spender,uint256 _value) returns(bool success);
3   function totalSupply() constant returns(uint256 );
4   function transferFrom(address _from,address _to,uint256 _value) returns(bool success);
5   function balanceOf(address _owner) constant returns(uint256 balance);
6   function transfer(address _to,uint256 _value) returns(bool success);
7   function allowance(address _owner,address _spender) constant returns(uint256 remaining);
8 }
9 
10 contract SwapContract {
11  
12   address public seller;
13   address public dgxContract;
14   uint256 public weiPrice;
15 
16   modifier ifSeller() {
17     if (seller != msg.sender) {
18       throw;
19     } else {
20       _
21     }
22   }
23 
24   function SwapContract(address _seller, uint256 _weiPrice) {
25     dgxContract = 0x55b9a11c2e8351b4ffc7b11561148bfac9977855;
26     seller = _seller;
27     weiPrice = _weiPrice;
28   }
29 
30   function () {
31     if (dgxBalance() == 0) throw;
32     if (msg.value < totalWeiPrice()) throw;
33     if (DgxToken(dgxContract).transfer(address(this), dgxBalance())) {
34       seller.send(msg.value);       
35     }
36   }
37 
38   function setWeiPrice(uint256 _newweiprice) ifSeller returns (bool _success) {
39     weiPrice = _newweiprice;
40     _success = true;
41     return _success;
42   }
43 
44   function totalWeiPrice() public constant returns (uint256 _totalweiprice) {
45     _totalweiprice = dgxBalance() * weiPrice;
46     return _totalweiprice;
47   }
48 
49   function dgxBalance() public constant returns (uint256 _dgxbalance) {
50     _dgxbalance = DgxToken(dgxContract).balanceOf(address(this));
51     return _dgxbalance;
52   }
53 
54   function withdraw() ifSeller returns (bool _success) {
55     _success = DgxToken(dgxContract).transfer(seller, dgxBalance());
56     return _success;
57   }
58 }
59 
60 contract DgxSwap {
61 
62   uint256 public totalCount;
63   mapping (address => address) public swapContracts;
64   mapping (uint256 => address) public sellers;
65 
66   function DgxSwap() {
67     totalCount = 0;
68   }
69 
70   function createSwap(uint256 _weiprice) public returns (bool _success) {
71     address _swapcontract = new SwapContract(msg.sender, _weiprice);
72     swapContracts[msg.sender] = _swapcontract;
73     sellers[totalCount] = msg.sender; 
74     totalCount++;
75     _success = true;
76     return _success;
77   }
78 
79   function getSwap(uint256 _id) public constant returns (address _seller, address _contract, uint256 _dgxbalance, uint256 _weiprice, uint256 _totalweiprice) {
80     _seller = sellers[_id];
81     if (_seller == 0x0000000000000000000000000000000000000000) {
82       _contract = 0x0000000000000000000000000000000000000000;
83       _dgxbalance = 0;
84       _weiprice = 0;
85       _totalweiprice = 0;
86     } else {
87       _contract = swapContracts[_seller];  
88       _dgxbalance = SwapContract(_contract).dgxBalance();
89       _weiprice = SwapContract(_contract).weiPrice();
90       _totalweiprice = SwapContract(_contract).totalWeiPrice();
91     }
92     return (_seller, _contract, _dgxbalance, _weiprice, _totalweiprice);
93   }
94 
95 }