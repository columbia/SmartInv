1 pragma solidity ^0.4.16;  
2 contract Token{  
3     uint256 public totalSupply;  
4   
5     function balanceOf(address _owner) public constant returns (uint256 balance);  
6     function transfer(address _to, uint256 _value) public returns (bool success);  
7     function transferFrom(address _from, address _to, uint256 _value) public returns     
8     (bool success);  
9   
10     function approve(address _spender, uint256 _value) public returns (bool success);  
11   
12     function allowance(address _owner, address _spender) public constant returns   
13     (uint256 remaining);  
14   
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);  
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);  
17 }  
18   
19 contract LhsToken is Token {  
20   
21     string public name;                   //名称，例如"My test token"  
22     uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.  
23     string public symbol;               //token简称,like MTT  
24     
25     mapping (address => uint256) balances;  
26     mapping (address => mapping (address => uint256)) allowed;  
27     
28     function LhsToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {  
29         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量  
30         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者  
31   
32         name = _tokenName;                     
33         decimals = _decimalUnits;            
34         symbol = _tokenSymbol;  
35     }  
36 
37 
38 
39     // token的发送函数
40     function _transferFunc(address _from, address _to, uint _value) internal {
41 
42         require(_to != 0x0);    // 不是零地址
43         require(balances[_from] >= _value);        // 有足够的余额来发送
44         require(balances[_to] + _value > balances[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
45 
46         uint previousBalances = balances[_from] + balances[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
47         balances[_from] -= _value; //发钱 不多说
48         balances[_to] += _value;
49         Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
50         assert(balances[_from] + balances[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
51     }
52   
53     function transfer(address _to, uint256 _value) public  returns (bool success) {
54         _transferFunc(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_value <= allowed[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
60         allowed[_from][msg.sender] -= _value;
61         _transferFunc(_from, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public constant returns (uint256 balance) {  
66         return balances[_owner];  
67     }  
68   
69     function approve(address _spender, uint256 _value) public returns (bool success)     
70     {   
71         allowed[msg.sender][_spender] = _value;  
72         Approval(msg.sender, _spender, _value);  
73         return true;  
74     }  
75   
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {  
77         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数  
78     }  
79 }