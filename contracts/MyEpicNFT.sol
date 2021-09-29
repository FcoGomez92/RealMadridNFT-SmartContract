// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><defs><style>@font-face{font-family:Press;src:url(data:application/font-woff2;charset=utf-8;base64,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)format('woff2')}.base{fill:#084b94;font-family:Press}</style></defs><rect width='100%' height='100%' fill='#F39528'/><rect width='98%' height='98%' x='1%' y='1%' fill='#042BA0'/><rect width='94%' height='94%' x='3%' y='3%' fill='#fff'/><text x='50%' y='33%' class='base' dominant-baseline='middle' text-anchor='middle' style='font-size:30px'>";
  string baseSvg2 = "</text><text x='50%' y='70%' class='base' dominant-baseline='middle' text-anchor='middle' style='font-size:120px'>";
  string baseSvg3 = "</text><circle cx='50%' cy='9%' r='13' fill='#042BA0'/><circle cx='50%' cy='9%' r='12.45' fill='#F39528'/><circle cx='50%' cy='9%' r='11.35' fill='#042BA0'/><circle cx='50%' cy='9%' r='8.6' fill='#F39528'/><circle cx='50%' cy='9%' r='7.5' fill='#042BA0'/><circle cx='50%' cy='9%' r='6.4' fill='#F39528'/><circle cx='50%' cy='9%' r='5.3' fill='#042BA0'/></svg>";

  string[] playerName = ["C.Ancelotti","Courtois","Carvajal","E. Militao","Alaba","Vallejo","Nacho","Hazard","Kroos","Benzema","Modric","Asensio","Marcelo","Lunin","Casemiro","Valverde","Jovic","Lucas V.","Bale","D.Ceballos","Vini Jr.","Rodrygo","Isco","F. Mendy","Mariano","Camavinga"];
  string[] playerNumber = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"];
  
  event NewEpicNFTMinted(address sender, uint256 tokenId, string playerName, string playerNumber);
  
  constructor() ERC721 ("RealMadridNFT s21-22", "RMCFs21-22") {
    console.log("I'm smart and unique. All my og's put your hands up!");
  }

  function pickRandomIndex(uint256 tokenId) public view returns (uint) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("Random_INDEX", Strings.toString(tokenId+block.difficulty+block.timestamp))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % playerName.length;
    return rand;
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    require(_tokenIds.current() < 99, "All the NFT's of this collection already minted. Now, you can buy them on OpenSea.");
    uint256 newItemId = _tokenIds.current()+1;
    

    uint index = pickRandomIndex(newItemId);

    string memory finalSvg = string(abi.encodePacked(baseSvg1,playerName[index],baseSvg2,playerNumber[index],baseSvg3));
    
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    '[#',Strings.toString(newItemId),'] - ',playerName[index],' ',playerNumber[index],
                    '", "description": "An NFT from the highly acclaimed Real Madrid Random Player collection", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId, playerName[index], playerNumber[index]);
  }

  function getTotalNFTsMinted() public view returns(uint){
    console.log("Total NFT's minted: %d", _tokenIds.current());
    return _tokenIds.current();
  }
} 