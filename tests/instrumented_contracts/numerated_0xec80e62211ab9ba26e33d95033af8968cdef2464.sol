1 contract TadamWhitelistPublicSale{
2     
3     mapping (address => bool) private owner;
4     mapping (address => bool) public canWhiteList;
5     mapping (address => uint) public PublicSaleWhiteListed; 
6     
7     function TadamWhitelistPublicSale(){
8         owner[msg.sender] = true;
9     }
10     event eWhitelisted(address _addr, uint _group);
11     
12 
13     function Whitelist(address _addr, uint _group) public{
14         /*
15             Adds an address to public sale white list
16             In Public Sale there are two types of white listed addresses
17             _group 1 : early whitelisted
18             _group 2 : late whitelisted
19         */
20         require( (canWhiteList[msg.sender]) && (_group >=0 && _group <= 2) );
21         PublicSaleWhiteListed[_addr] = _group;
22     }
23     
24     function addWhiteLister(address _address) public onlyOwner {
25         canWhiteList[_address] = true;
26     }
27     
28     function removeWhiteLister(address _address) public onlyOwner {
29         canWhiteList[_address] = false;
30     }
31     
32     function isWhiteListed(address _addr) returns (uint _group){
33         var group = PublicSaleWhiteListed[_addr];
34         eWhitelisted(_addr, group);
35         return group;
36     }
37 
38     
39     modifier onlyOwner(){
40         require(owner[msg.sender]);
41         _;
42     }
43     
44 }