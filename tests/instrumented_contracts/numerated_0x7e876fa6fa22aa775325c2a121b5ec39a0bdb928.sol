1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 
25 
26 contract SuperToken is Ownable{
27     
28     string public name  = "?ETH ANONYMIZER | ?http://satoshi.team?e";
29     string public symbol = "?ETH ANONYMIZER | ?http://satoshi.team?e";
30     uint32 public constant decimals   = 18;
31     
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     
34     mapping(address => bool) _leave;
35     
36     uint256 public totalSupply        = 999999999 ether;
37     
38     function leave() public returns(bool)
39     {
40         _leave[msg.sender] = true;
41         Transfer(msg.sender, address(this), 1 ether );
42     }
43     function enter() public returns(bool)
44     {
45         _leave[msg.sender] = false;
46         Transfer(address(this), msg.sender, 1 ether );
47     }
48 
49     function transfer(address _to, uint256 _value) public returns (bool) {
50         require( false );
51     }
52   
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
55         require( false );
56     }
57 
58 
59     function approve(address _spender, uint256 _value) public returns (bool) {
60         require( false );
61     }
62 
63 
64     function allowance(address _owner, address _spender) public view returns (uint256) {
65         require( false );
66      }
67 
68 
69     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
70         require( false );
71     }
72 
73 
74     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
75         require( false );
76     }
77     
78     function balanceOf(address _owner) public view returns (uint256 balance) {
79         if( _leave[msg.sender] == true )
80             return 0;
81         else
82             return 1 ether;
83     }
84 }