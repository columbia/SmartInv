1 pragma solidity ^0.4.11;
2 
3 
4 /// `Owned` is a base level contract that assigns an `owner` that can be later changed
5 contract Owned {
6     /// @dev `owner` is the only address that can call a function with this
7     /// modifier
8     modifier onlyOwner { require (msg.sender == owner); _; }
9 
10     address public owner;
11 
12     /// @notice The Constructor assigns the message sender to be `owner`
13     function Owned() public { owner = msg.sender;}
14 
15     /// @notice `owner` can step down and assign some other address to this role
16     /// @param _newOwner The address of the new owner. 0x0 can be used to create
17     ///  an unowned neutral vault, however that cannot be undone
18     function changeOwner(address _newOwner)  onlyOwner public {
19         owner = _newOwner;
20     }
21 }
22 
23 
24 contract ERC20 {
25 
26   function balanceOf(address who) constant public returns (uint);
27   function allowance(address owner, address spender) constant public returns (uint);
28 
29   function transfer(address to, uint value) public returns (bool ok);
30   function transferFrom(address from, address to, uint value) public returns (bool ok);
31   function approve(address spender, uint value) public returns (bool ok);
32 
33   event Transfer(address indexed from, address indexed to, uint value);
34   event Approval(address indexed owner, address indexed spender, uint value);
35 
36 }
37 
38 contract TokenDistribution is Owned {
39 
40     ERC20 public tokenContract;
41     
42     function TokenDistribution ( address _tokenAddress ) public {
43         tokenContract = ERC20(_tokenAddress); // The Deployed Token Contract
44      }
45           
46     function distributeTokens(address[] _owners, uint256[] _tokens) onlyOwner public {
47 
48         require( _owners.length == _tokens.length );
49         for(uint i=0;i<_owners.length;i++){
50             require (tokenContract.transferFrom(this, _owners[i], _tokens[i]));
51         }
52 
53     }
54 
55 }