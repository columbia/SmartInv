1 contract ERC20TokenInterface {
2   function totalSupply() public constant returns (uint256 _totalSupply);
3   function balanceOf(address _owner) public constant returns (uint256 balance);
4   function transfer(address _to, uint256 _value) public returns (bool success);
5   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6   function approve(address _spender, uint256 _value) public returns (bool success);
7   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
8 
9   event Transfer(address indexed _from, address indexed _to, uint256 _value);
10   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 
14 contract Owned {
15     address public owner;
16     address public newOwner;
17 
18     function Owned() {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner {
23         assert(msg.sender == owner);
24         _;
25     }
26 
27     function transferOwnership(address _newOwner) public onlyOwner {
28         require(_newOwner != owner);
29         newOwner = _newOwner;
30     }
31 
32     function acceptOwnership() public {
33         require(msg.sender == newOwner);
34         OwnerUpdate(owner, newOwner);
35         owner = newOwner;
36         newOwner = 0x0;
37     }
38 
39     event OwnerUpdate(address _prevOwner, address _newOwner);
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