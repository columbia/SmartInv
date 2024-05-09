1 pragma solidity ^ 0.4 .25;
2 
3 contract BSAFEWhiteList  {
4     
5     address public owner;
6     
7     mapping ( address => bool ) public whitelist;
8     mapping ( address => bool ) public blacklist;
9     
10     event AddressWhiteListed(address _whitelisted);
11     event AddressDeWhiteListed(address _dewhitelisted);
12     event AddressBlackListed(address _blacklisted);
13     event AddressDeBlackListed(address _dewhitelisted);
14     
15     
16     
17     modifier onlyOwner {
18 		require( msg.sender == owner );
19 		_;
20 	}
21     
22    
23     constructor(){
24         
25         owner = msg.sender;
26         
27     }
28    
29    
30    function whitelistAddress( address _address ) public onlyOwner{
31        
32        whitelist[ _address ] = true;
33        emit AddressWhiteListed( _address);
34        
35        
36    }
37    
38    
39    function blacklistAddress( address _address ) public onlyOwner{
40        
41        blacklist[ _address ] = true;
42        emit AddressBlackListed( _address);
43        
44    }
45    
46    
47    function dewhitelistAddress( address _address ) public onlyOwner{
48        
49        whitelist[ _address ] = false;
50        emit AddressDeWhiteListed( _address);
51        
52        
53    }
54    
55    
56    function deblacklistAddress( address _address ) public onlyOwner{
57        
58        blacklist[ _address ] = false;
59        emit AddressDeBlackListed( _address);
60        
61        
62    }
63    
64    
65    function checkAddress ( address _address ) constant public returns(bool) {
66        
67        if ( whitelist [ _address ] == true && blacklist[ _address ] == false ) return true;
68        
69        return false;
70        
71    }
72    
73    
74    function changeOwner( address _newowner ) public onlyOwner {
75        
76        owner = _newowner;
77        
78    }
79    
80 }