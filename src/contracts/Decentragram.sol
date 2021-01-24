pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // store images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // create images
  function uploadImage(string memory _imgHash, string memory _description) public {
    // check for existing image description
    require(bytes(_description).length > 0);
    // check for existing image hash
    require(bytes(_imgHash).length > 0);
    // check for existing sender hash
    require(msg.sender != address(0x0));

    // increment image id
    imageCount += 1;

    // create image and emit 
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender); // message from user uploading image
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Tip images
  function tipImageOwner(uint _id) public payable {
    // Make sure the id is valid
    require(_id > 0 && _id <= imageCount);

    // send image author some money
    Image memory _image = images[_id];
    address payable _author = _image.author;
    address(_author).transfer(msg.value);
    // Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    // put image back in the mapping
    images[_id] = _image;
    emit ImageTipped(_id, _image.hash, _image.description, msg.value, _author);
  }
}