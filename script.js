let ipfs;

document
  .getElementById("uploadButton")
  .addEventListener("click", async function () {
    console.log("inside function")

    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];

    if (file) {
      const reader = new FileReader();

      reader.onload = function (event) {
        const img = new Image();
        img.src = event.target.result;
        console.log("inside reader.onload")

        img.onload = function () {
          const canvas = document.createElement("canvas");
          const ctx = canvas.getContext("2d");
          canvas.width = img.width;
          canvas.height = img.height;
          ctx.drawImage(img, 0, 0);
          canvas.toBlob(
            async function (blob) {
              console.log(blob);
              uploadToIPFS(blob);
            },
            "image/jpeg",
            0.95
          );
        };
      };
      reader.readAsDataURL(file);
    } else {
      alert("Please select an image file to upload.");
    }


  });


async function uploadToIPFS(blob) {
  

  const cid = await heliaFs.addFile({
    content: blob,
  });

  console.log("Successfully stored", cid.toString());
  document.getElementById("result").innerText = `CID: ${cid.toString()}`;
}


const connect = async (e) => {
  try {
    const http = KuboRpcClient.create('/ip4/127.0.0.1/tcp/5001')
    const isOnline = await http.isOnline()

    if (isOnline) {
      ipfs = http;
    }
  }
  catch(err) {
    console.error(err.message)
  }
}
connect()