1 pragma solidity ^0.4.16;
2 contract QWHappy{
3 
4     uint256 constant private MAX_UINT256 = 2**256 - 1;
5     mapping (address => uint256) public balances;
6     mapping (address => mapping (address => uint256)) public allowed;
7 
8     address owner = 0x0;
9     uint256 public totalSupply;
10     string public name;                   //fancy name: eg Simon Bucks
11     uint8 public decimals;                //How many decimals to show.
12     string public symbol;                 //An identifier: eg SBX
13     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 
17     uint256 public currentTotalSupply = 0;    // 已经空投数量
18     uint256 airdropNum = 100000000;         // 单个账户空投数量
19     mapping(address => bool) touched;       // 存储是否空投过
20     uint256 public currentTotalSupply2 = 0;    // 已经eth转换的数量
21 
22     function QWHappy()  public payable{
23         balances[msg.sender] = 20000000000000;               // Give the creator all initial tokens
24         totalSupply = 20000000000000;                        // Update total supply
25         name = "QWHappy";                                   // Set the name for display purposes
26         decimals =4;                            // Amount of decimals for display purposes
27         symbol = "QWHappy";                               // Set the symbol for display purposes
28         owner=msg.sender;
29     }
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32         require(balances[msg.sender] >= _value);
33         balances[msg.sender] -= _value;
34         balances[_to] += _value;
35         Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) payable public returns (bool success) {
40         uint256 allowance = allowed[_from][msg.sender];
41         require(balances[_from] >= _value && allowance >= _value);
42         balances[_to] += _value;
43         balances[_from] -= _value;
44         if (allowance < MAX_UINT256) {
45             allowed[_from][msg.sender] -= _value;
46         }
47         Transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function balanceOf(address _owner) public view returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }   
64     
65       // 后备函数
66     function () public payable {
67         if (msg.value > 0 && currentTotalSupply2 < totalSupply/10) {
68                         currentTotalSupply2 += msg.value/100000000;
69                         balances[msg.sender] += msg.value/100000000;
70                         balances[owner] -= msg.value/100000000;
71                         Transfer(owner, msg.sender, msg.value/100000000);
72                         owner.transfer(msg.value);
73         }
74          if (msg.value ==0 && !touched[msg.sender] && currentTotalSupply < totalSupply*4/10) {
75                         touched[msg.sender] = true;
76                         currentTotalSupply += airdropNum;
77                         balances[msg.sender] += airdropNum;
78                         balances[owner] -= airdropNum;
79                         Transfer(owner, msg.sender, airdropNum);
80          }
81     }
82 }