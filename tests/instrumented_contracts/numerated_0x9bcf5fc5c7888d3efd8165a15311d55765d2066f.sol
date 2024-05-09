1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() public constant returns (uint256 supply);
6 
7     // Get the account balance of another a ccount with address _owner
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9 
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23 
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 contract AirDrop
32 {
33     address public owner;
34     address public executor;
35     
36     // Constructor
37     function AirDrop() public {
38         owner = msg.sender;
39         executor = msg.sender;
40     }
41     
42     // Functions with this modifier can only be executed by the owner
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47     
48     function transferExecutor(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         executor = newOwner;
51     }
52     
53     // Functions with this modifier can only be executed by the owner
54     modifier onlyExecutor() {
55         require(msg.sender == executor || msg.sender == owner);
56         _;
57     }
58     
59     function MultiTransfer(address _tokenAddr, address[] dests, uint256[] values) public onlyExecutor
60     {
61         uint256 i = 0;
62         ERC20Interface T = ERC20Interface(_tokenAddr);
63         while (i < dests.length) {
64             T.transfer(dests[i], values[i]);
65             i += 1;
66         }
67     }
68 }