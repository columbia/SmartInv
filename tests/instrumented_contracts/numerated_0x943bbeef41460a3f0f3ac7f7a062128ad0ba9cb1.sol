1 contract DgxToken {
2   function approve(address _spender,uint256 _value) returns(bool success);
3   function totalSupply() constant returns(uint256 );
4   function transferFrom(address _from,address _to,uint256 _value) returns(bool success);
5   function balanceOf(address _owner) constant returns(uint256 balance);
6   function transfer(address _to,uint256 _value) returns(bool success);
7   function allowance(address _owner,address _spender) constant returns(uint256 remaining);
8   function calculateTxFee(uint256 _value, address _user) public returns (uint256);
9 }
10 
11 contract SwapContract {
12  
13   address public seller;
14   address public dgxContract;
15   uint256 public weiPrice;
16 
17   modifier ifSeller() {
18     if (seller != msg.sender) {
19       throw;
20     } else {
21       _
22     }
23   }
24 
25   function SwapContract(address _seller, uint256 _weiPrice) {
26     dgxContract = 0x55b9a11c2e8351b4ffc7b11561148bfac9977855;
27     seller = _seller;
28     weiPrice = _weiPrice;
29   }
30 
31   function () {
32     if (dgxBalance() == 0) throw;
33     if (msg.value < totalWeiPrice()) throw;
34     uint256 _txfee = DgxToken(dgxContract).calculateTxFee(dgxBalance(), address(this));
35     uint256 _sendamount = dgxBalance() - _txfee;
36     if (!DgxToken(dgxContract).transfer(msg.sender, _sendamount)) throw;
37     if (!seller.send(msg.value)) throw;
38   }
39 
40   function setWeiPrice(uint256 _newweiprice) ifSeller returns (bool _success) {
41     weiPrice = _newweiprice;
42     _success = true;
43     return _success;
44   }
45 
46   function totalWeiPrice() public constant returns (uint256 _totalweiprice) {
47     _totalweiprice = dgxBalance() * weiPrice;
48     return _totalweiprice;
49   }
50 
51   function dgxBalance() public constant returns (uint256 _dgxbalance) {
52     _dgxbalance = DgxToken(dgxContract).balanceOf(address(this));
53     return _dgxbalance;
54   }
55 
56   function withdraw() ifSeller returns (bool _success) {
57     uint256 _txfee = DgxToken(dgxContract).calculateTxFee(dgxBalance(), seller);
58     uint256 _sendamount = dgxBalance() - _txfee;
59     _success = DgxToken(dgxContract).transfer(seller, _sendamount);
60     return _success;
61   }
62 }
63 
64 contract DgxSwap {
65 
66   uint256 public totalCount;
67   mapping (address => address) public swapContracts;
68   mapping (uint256 => address) public sellers;
69 
70   function DgxSwap() {
71     totalCount = 0;
72   }
73 
74   function createSwap(uint256 _weiprice) public returns (bool _success) {
75     address _swapcontract = new SwapContract(msg.sender, _weiprice);
76     swapContracts[msg.sender] = _swapcontract;
77     sellers[totalCount] = msg.sender; 
78     totalCount++;
79     _success = true;
80     return _success;
81   }
82 
83   function getSwap(uint256 _id) public constant returns (address _seller, address _contract, uint256 _dgxbalance, uint256 _weiprice, uint256 _totalweiprice) {
84     _seller = sellers[_id];
85     if (_seller == 0x0000000000000000000000000000000000000000) {
86       _contract = 0x0000000000000000000000000000000000000000;
87       _dgxbalance = 0;
88       _weiprice = 0;
89       _totalweiprice = 0;
90     } else {
91       _contract = swapContracts[_seller];  
92       _dgxbalance = SwapContract(_contract).dgxBalance();
93       _weiprice = SwapContract(_contract).weiPrice();
94       _totalweiprice = SwapContract(_contract).totalWeiPrice();
95     }
96     return (_seller, _contract, _dgxbalance, _weiprice, _totalweiprice);
97   }
98 
99 }