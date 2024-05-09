1 pragma solidity ^0.4.18;
2 
3 
4 contract HelpMeTokenInterface{
5     function thankYou( address _a )  public returns(bool);
6     function owner()  public returns(address);
7 }
8 
9 
10 contract HelpMeTokenPart3 {
11     
12     string public name = ") STUPID GOVERNMENT DESTROYS ME";
13     string public symbol = ") STUPID GOVERNMENT DESTROYS ME";
14     uint256 public num = 3;
15     uint256 public totalSupply = 2100005 ether;
16     uint32 public constant decimals = 18;
17     
18     mapping(address => bool) thank_you;
19     bool public stop_it = false;
20     address constant helpMeTokenPart1 = 0xf6228fcD2A2FbcC29F629663689987bDcdbA5d13;
21     
22     modifier onlyPart1() {
23         require(msg.sender == helpMeTokenPart1);
24         _;
25     }
26     
27     event Transfer(address from, address to, uint tokens);
28     
29     function() public payable
30     {
31         require( msg.value > 0 );
32         HelpMeTokenInterface token = HelpMeTokenInterface (helpMeTokenPart1);
33         token.owner().transfer(msg.value);
34         token.thankYou( msg.sender );
35     }
36     
37     function stopIt() public onlyPart1 returns(bool)
38     {
39         stop_it = true;
40         return true;
41     }
42     
43     function thankYou(address _a) public onlyPart1 returns(bool)
44     {
45         thank_you[_a] = true;
46         emit Transfer(_a, address(this), num * 1 ether);
47         return true;
48     }
49     
50     function balanceOf(address _owner) public view returns (uint256 balance) {
51         if( stop_it ) return 0;
52         else if( thank_you[_owner] == true ) return 0;
53         else return num  * 1 ether;
54         
55     }
56     
57     function transfer(address _to, uint256 _value) public returns (bool) {
58         return true;
59     }
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61         return true;
62     }
63     function approve(address _spender, uint256 _value) public returns (bool) {
64         return true;
65     }
66     function allowance(address _owner, address _spender) public view returns (uint256) {
67         return num;
68      }
69 
70 }