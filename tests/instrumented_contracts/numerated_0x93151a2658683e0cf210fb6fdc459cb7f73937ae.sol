1 pragma solidity >=0.5.0;
2 
3 // Letétszerződés. A letétbe helyezett ETH összeget csak a kedvezményezettnek lehet kifizetni.
4 contract Escrow {
5 
6     // Tulajdonos
7     address owner;
8     // Kedvezményezett
9     address payable constant beneficiary = 0x168cF76582Cd7017058771Df6F623882E04FCf0F;
10 
11     // Szerződés létrehozása
12     constructor() public {
13         owner = msg.sender; // Tulajdonos beállítása
14     }
15     
16     // Bizonyos dolgokat csak a tulajdonos kezdeményezhet.
17     modifier ownerOnly {
18         assert(msg.sender == owner);
19         _;
20     }
21     
22     // Csak a tulajdonos utalhat ki étert a szerződésből
23     function transfer(uint256 amount) ownerOnly public {
24         beneficiary.transfer(amount); // Csak a kezdvezményezettnek
25     }
26     
27     // Csak a tulajdonos semmisítheti meg a szerződést
28     function terminate() ownerOnly public {
29         selfdestruct(beneficiary); // Minden befizetést megkap a kedvezményezett
30     }
31     
32     // Bárki bármennyit befizethet a szerződésbe.
33     function () payable external {}
34 }