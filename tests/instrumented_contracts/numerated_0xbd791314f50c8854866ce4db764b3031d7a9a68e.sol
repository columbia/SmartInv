1 contract Owned {
2     address public owner;
3     address public newOwner;
4 
5     function Owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         assert(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address _newOwner) public onlyOwner {
15         require(_newOwner != owner);
16         newOwner = _newOwner;
17     }
18 
19     function acceptOwnership() public {
20         require(msg.sender == newOwner);
21         OwnerUpdate(owner, newOwner);
22         owner = newOwner;
23         newOwner = 0x0;
24     }
25 
26     event OwnerUpdate(address _prevOwner, address _newOwner);
27 }
28 
29 
30 contract ERC20TokenInterface {
31   function totalSupply() public constant returns (uint256 _totalSupply);
32   function balanceOf(address _owner) public constant returns (uint256 balance);
33   function transfer(address _to, uint256 _value) public returns (bool success);
34   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35   function approve(address _spender, uint256 _value) public returns (bool success);
36   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38   event Transfer(address indexed _from, address indexed _to, uint256 _value);
39   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 contract KycContract is Owned {
44     
45     mapping (address => bool) verifiedAddresses;
46     
47     function isAddressVerified(address _address) public view returns (bool) {
48         return verifiedAddresses[_address];
49     }
50     
51     function addAddress(address _newAddress) public onlyOwner {
52         require(!verifiedAddresses[_newAddress]);
53         
54         verifiedAddresses[_newAddress] = true;
55     }
56     
57     function removeAddress(address _oldAddress) public onlyOwner {
58         require(verifiedAddresses[_oldAddress]);
59         
60         verifiedAddresses[_oldAddress] = false;
61     }
62     
63     function batchAddAddresses(address[] _addresses) public onlyOwner {
64         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
65             assert(!verifiedAddresses[_addresses[cnt]]);
66             verifiedAddresses[_addresses[cnt]] = true;
67         }
68     }
69     
70     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
71         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
72     }
73     
74     function killContract() public onlyOwner {
75         selfdestruct(owner);
76     }
77 }