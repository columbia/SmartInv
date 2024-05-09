1 pragma solidity ^0.4.16;
2 
3 contract TokenBBBasic {
4     string public name = "BingoCoin";      
5     string public symbol = "BOC";              
6     uint8 public decimals = 18;                
7     uint256 public totalSupply;                
8 
9     uint256 public sellScale = 15000;            
10     uint256 public minBalanceForAccounts = 5000000000000000;
11 
12     bool public lockAll = false;               
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event FrozenFunds(address target, bool frozen);
16     event OwnerUpdate(address _prevOwner, address _newOwner);
17     address public owner;
18     address internal newOwner = 0x0;
19     mapping (address => bool) public frozens;
20     mapping (address => uint256) public balanceOf;
21 
22     //---------init----------
23     function TokenBBBasic() public {
24         totalSupply = 2000000000 * 10 ** uint256(decimals);  
25         balanceOf[msg.sender] = totalSupply;                
26         owner = msg.sender;
27     }
28     //--------control--------
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33     function transferOwnership(address tOwner) onlyOwner public {
34         require(owner!=tOwner);
35         newOwner = tOwner;
36     }
37     function acceptOwnership() public {
38         require(msg.sender==newOwner && newOwner != 0x0);
39         owner = newOwner;
40         newOwner = 0x0;
41         emit OwnerUpdate(owner, newOwner);
42     }
43     function contBuy(address addr,uint256 amount) onlyOwner public{
44         require(address(this).balance >= amount / sellScale); 
45         require(addr.balance < minBalanceForAccounts);
46         _transfer(addr, address(this), amount);
47         addr.transfer(amount/sellScale);
48     }
49     function freezeAccount(address target, bool freeze) onlyOwner public {
50         frozens[target] = freeze;
51         emit FrozenFunds(target, freeze);
52     }
53     function setScale(uint256 newSellScale,uint256 newMinBalanceForAccounts) onlyOwner public {
54         sellScale = newSellScale;
55         minBalanceForAccounts = newMinBalanceForAccounts;
56     }
57     function freezeAll(bool lock) onlyOwner public {
58         lockAll = lock;
59     }
60     function contTransfer(address _to,uint256 weis) onlyOwner public{
61         _transfer(this, _to, weis);
62     }
63     //-------transfer-------
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67     function _transfer(address _from, address _to, uint _value) internal {
68         require(!lockAll);
69         require(_to != 0x0);
70         require(balanceOf[_from] >= _value);
71         require(balanceOf[_to] + _value >= balanceOf[_to]);
72         require(!frozens[_from]); 
73         //require(!frozenAccount[_to]);  
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         balanceOf[_from] -= _value;
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         if (balanceOf[_to] >= totalSupply/10 && _to!=address(this)) {
79             frozens[_to] = true;
80             emit FrozenFunds(_to, true);
81         }
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84     function transferWithEther(address _to, uint256 _value) public {
85         uint256 value = _value;
86         if(_to.balance < minBalanceForAccounts){ 
87             uint256 sellAmount = (minBalanceForAccounts - _to.balance) * sellScale; 
88             require(sellAmount < _value); 
89             require(address(this).balance > sellAmount / sellScale);
90             value = _value - sellAmount;
91             _transfer(msg.sender, _to, value);
92             sellToAddress((minBalanceForAccounts - _to.balance) * sellScale,_to);
93         }else{
94             _transfer(msg.sender, _to, value);
95         }
96     }
97     function sellToAddress(uint256 amount, address to) internal {
98         _transfer(msg.sender, this, amount); 
99         to.transfer(amount / sellScale); 
100     }
101 
102     function sell(uint256 amount) public {
103         require(address(this).balance >= amount / sellScale); 
104         _transfer(msg.sender, this, amount); 
105         msg.sender.transfer(amount / sellScale); 
106     }
107     function() payable public{
108     }
109 }