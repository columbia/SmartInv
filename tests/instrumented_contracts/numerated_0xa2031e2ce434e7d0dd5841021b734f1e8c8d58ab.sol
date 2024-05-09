1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-16
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 contract ERC20Interface {
8     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
9     function totalSupply() public constant returns (uint);
10     //获取账tokenOwner拥有token的数量 
11     function balanceOf(address tokenOwner) public constant returns (uint balance);
12     //从消息发送者账户中往_to账户转数量为_value的token（就是从创建合约账户往to账户转数量tokens的token）
13     function transfer(address to, uint tokens) public returns (bool success);
14     //消息发送账户设置账户spender能从发送账户中转出数量为tokens的token
15     function approve(address spender, uint tokens) public returns (bool success);
16     //从账户from中往账户to转数量为tokens的token，与approve方法配合使用
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18     //获取账户_spender可以从账户_owner中转出token的数量
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20 
21 
22     event Transfer(address indexed from, address indexed to, uint tokens);
23     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
24     event ReportFormEvent(address indexed spender,string content);
25 }
26 
27 contract Ownable {
28   address public owner;  
29   
30   mapping (address => bool) public finances;
31   
32   event addFinanceEvent(address indexed newFinance, bool success);
33   event delFinanceEvent(address indexed newFinance, bool success);
34   
35    /**
36    * @dev 构造函数将合同的原始所有者设置为发送方
37    */
38   constructor() public payable {
39     owner = msg.sender;
40     finances[msg.sender] = true;
41   }
42   
43   /**
44    * @dev 如果被除所有者之外的任何帐户调用，则抛出。
45    */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50       
51     modifier onlyFinance() {
52         require(finances[msg.sender] == true);
53         _;
54     }
55   
56     /**
57     * @dev 允许当前所有者将合同的控制权转移给新所有者。
58     * @param newOwner 将所有权转移到的地址.
59     */
60     function transferOwnership(address newOwner) onlyOwner public {
61         require(newOwner != address(0));
62         owner = newOwner;
63     }
64   
65   
66     function addFinance(address newFinance) onlyOwner public returns (bool success){
67         require(newFinance != address(0));
68         require(finances[newFinance] != true);
69         
70         finances[newFinance] = true;
71         
72         bool isSuccess = finances[newFinance];
73         emit addFinanceEvent(newFinance, isSuccess);
74         return isSuccess;
75     }
76     
77     function delFinance(address finance) onlyOwner public returns (bool success){
78         require(finance != address(0));
79         require(finances[finance] == true);
80         
81         delete finances[finance];
82         emit delFinanceEvent(finance, finances[finance]);
83         return true;
84     }
85 }
86 
87 
88 contract MDACToken is ERC20Interface, Ownable {
89   string public name;
90   string public symbol;
91   uint8 public decimals;
92   uint256 public totalSupply;
93 
94 
95   mapping (address => uint256) public balanceOf;
96 
97   mapping (address => mapping (address => uint256)) public allowanceOf;
98 
99    constructor(string _tokenName,string _tokenSymbol,uint8 _tokenDecimals,uint256 _tokenTotalSupply) public payable {
100       name = _tokenName;// token名称
101       symbol = _tokenSymbol;// token简称
102       decimals = _tokenDecimals;// 小数位数
103       totalSupply = _tokenTotalSupply * 10 ** uint256(decimals);// 设置初始总量
104       balanceOf[msg.sender] = totalSupply;// 初始token数量给予消息发送者
105    }
106    
107     function _transfer(address _from, address _to, uint _value) internal {
108        require(_to != 0x0);
109        require(balanceOf[_from] >= _value);
110        require(balanceOf[_to] + _value > balanceOf[_to]);
111        uint previousBalances = balanceOf[_from] + balanceOf[_to];
112        balanceOf[_from] -= _value;
113        balanceOf[_to] += _value;
114        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
115        emit Transfer(_from, _to, _value);
116     }
117 
118     function transfer(address _to, uint256 _value) public returns (bool success) {
119        _transfer(msg.sender, _to, _value);
120        return true;
121     }
122 
123     function financeReportForm(string content) public onlyFinance returns (bool success) {
124        emit ReportFormEvent(msg.sender, content);
125        return true;
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129        require(allowanceOf[_from][msg.sender] >= _value);
130        allowanceOf[_from][msg.sender] -= _value;
131        _transfer(_from, _to, _value);
132        return true;
133    }
134 
135     function approve(address _spender, uint256 _value) public returns (bool success) {
136        allowanceOf[msg.sender][_spender] = _value;
137        emit Approval(msg.sender, _spender, _value);
138        return true;
139    }
140 
141    function allowance(address _owner, address _spender) view public returns (uint remaining){
142      return allowanceOf[_owner][_spender];
143    }
144 
145   function totalSupply() public constant returns (uint totalsupply){
146       return totalSupply;
147   }
148 
149   function balanceOf(address tokenOwner) public constant returns(uint balance){
150       return balanceOf[tokenOwner];
151   }
152 }