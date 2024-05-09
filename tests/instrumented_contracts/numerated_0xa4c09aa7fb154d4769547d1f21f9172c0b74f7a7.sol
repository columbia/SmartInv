1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     /**
8      * The address whcih deploys this contrcat is automatically assgined ownership.
9      * */
10     function Ownable() public {
11         owner = msg.sender;
12     }
13 
14     /**
15      * Functions with this modifier can only be executed by the owner of the contract. 
16      * */
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     event OwnershipTransferred(address indexed from, address indexed to);
23 
24     /**
25     * Transfers ownership to new Ethereum address. This function can only be called by the 
26     * owner.
27     * @param _newOwner the address to be granted ownership.
28     **/
29     function transferOwnership(address _newOwner) public onlyOwner {
30         require(_newOwner != 0x0);
31         OwnershipTransferred(owner, _newOwner);
32         owner = _newOwner;
33     }
34 }
35 
36 contract TokenInterface {
37     function balanceOf(address _owner) public view returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 
42 contract SelfDropLMA is Ownable {
43     
44     TokenInterface public constant LMDA = TokenInterface(0xdF0456311751799f7036b373Cdb6f6dfdE04E3b6);
45     TokenInterface public constant LMA = TokenInterface(0xBAd1a84D8BB34CBb20A0884FA2B9714323530558);
46     
47     mapping (address => uint256) public balances;
48     
49     function initBalances(address[] _addrs) public onlyOwner {
50         for(uint i=0; i < _addrs.length; i++) {
51             balances[_addrs[i]] = LMDA.balanceOf(_addrs[i]);
52         }
53     }
54     
55     function getBalanceOf(address _owner) public view returns(uint256) {
56         return balances[_owner];
57     }
58     
59     function() public payable {
60         if(msg.value > 0) {
61             msg.sender.transfer(msg.value);
62         }
63         uint256 toTransfer = balances[msg.sender];
64         balances[msg.sender] = 0;
65         LMA.transfer(msg.sender, toTransfer);
66     }
67     
68     function withdrawTokens(uint256 _value) public onlyOwner {
69         LMA.transfer(owner, _value);
70     }
71     
72 }