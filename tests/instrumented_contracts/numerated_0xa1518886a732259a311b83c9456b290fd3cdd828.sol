1 pragma solidity 0.4.19;
2 
3 contract TokenDeskProxySupport {
4     function buyTokens(address sender_, address benefeciary_, uint256 tokenDeskBonus_) external payable;
5 }
6 
7 contract TokenDeskProxy {
8     TokenDeskProxySupport private tokenDeskProxySupport;
9     uint256 public bonus;
10 
11     function TokenDeskProxy(address _tokenDeskProxySupport, uint256 _bonus) public {
12         require(_tokenDeskProxySupport != address(0));
13         tokenDeskProxySupport = TokenDeskProxySupport(_tokenDeskProxySupport);
14         bonus = _bonus;
15     }
16 
17     function () public payable {
18         tokenDeskProxySupport.buyTokens.value(msg.value)(msg.sender, msg.sender, bonus);
19     }
20 }