1 pragma solidity ^0.4.25;
2 
3 /*                                                                                                                   
4                                                                                                                                                             
5                   :$%`                                                                                                                                      
6                 .!|':$:                                                                                                                                     
7                '%;   `%!.                                                                                                                                   
8       .'.     ;%'      !%`     '`                                               '!'                :|||!;`                             .;|'       .;|'      
9       '$$$$!:||.        :$;:%$$$!           '$;         :$'      '`       '.    :$:               .!%' .:%$:                             :$%`    ;$|.       
10       ;%%%';$$$!`      :%$$%:!%%%`          :$;                :%'      ;|`     :$:               .!%`   :$;                               !$! '%%'         
11      .|;.;$|`  .;%$$$$|'   :$|`'%:          :$;         :$'  `!$$%|;. '|$$||:   :$:    :$%;!%%`   .!$!;!%$:     .|$|;|$;    `|$!;|$;        `|$$;           
12      '%::$$%' `|$$!`'|$$;..!$$|:!!          :$;         :$'    !|`     .|!.     :$:   :$;...'|!.  .!%:``'!$%`  .!%'...;$:  .||'...;$:       ;$$$|`          
13      ;$$|':%$%:         .!$$|';$$%`         :$;         :$'    !|`     .|!.     :$:   :$:         .!%`    '%|. .!|.        .|!.           '%%'  !$;         
14     .!$$$|` '%:         .|!. :%$$$:         :$!`....    :$'    ;$: ''  .!%' `.  :$:    !$!` .;;.  .!%' .`;%$:   '%%:. `!'   '$%:. '!'   .!$;     `%$:       
15     .!$!.    '%;       `|!.    '%$:         `!!!!!!`    '!`     `;!:.    `;!'   `!`      '!!;`     :!!!!!:.       .;!!:.      `;!;'    `!;.        '!:      
16        '%%:   '%;     `|!   .!$!.                                                                                                                           
17           ;$|. `%;   `%;  '%%'                                                                                                                              
18             `%$:'|! '%;`|$!                 `;....''... `''':``. .`;`  .'`.`:'`''''''```.'..'``. .':``'..  ::`. .''.  ''`.  ':`.`'..:` `'......` .`'`..     
19                ;$$$$$$$%`                   .'.`'``..'. .. ''```'`.'.  .'`.`''`. .`. .``'..' ..  .''``..'  .. . .''.  `:'``.''`.`'.`'`.`'.`..``````..'`     
20                  `|$$;                                                                                                                                      
21                                                                                                                                                             
22 
23 */                                                                                                                                                   
24 
25 contract Ownable {
26     address public owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         owner = newOwner;
42         emit OwnershipTransferred(owner, newOwner);
43     }
44 }
45 
46 contract ERC20 {
47     function allowance(address owner, address spender) public view returns (uint256);
48 
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50 
51     function approve(address spender, uint256 value) public returns (bool);
52 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54     
55     function balanceOf(address owner) public view returns (uint256);
56      
57     function symbol() public view returns (string);
58       
59     function decimals() public view returns (uint);  
60       
61     function totalSupply() public view returns (uint256);
62 }
63 
64 
65 contract LittleBeeX_Sender is Ownable {
66     function multisend(address _tokenAddr, address[] dests, uint256[] values) public onlyOwner returns (uint256) {
67         uint256 i = 0;
68         while (i < dests.length) {
69            ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
70            i += 1;
71         }
72         return(i);
73     }
74     
75     function searchTokenMsg ( address _tokenAddr ) public view returns (string,uint256,uint256,uint256){
76         uint size = (10 ** ERC20(_tokenAddr).decimals());
77         return( ERC20(_tokenAddr).symbol(),ERC20(_tokenAddr).totalSupply() / size,ERC20(_tokenAddr).balanceOf(msg.sender) / size,ERC20(_tokenAddr).allowance(msg.sender,this) / size);
78     }
79 }