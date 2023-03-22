# Example to create a bios compatible gpt partition
{ lib, disks ? [ "/dev/sda" ], ... }: {
  disk = lib.genAttrs disks (dev: {
    device = dev;
    type = "disk";
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          type = "partition";
          name = "swap";
          start = "0MiB";
          end = "512MiB";
          part-type = "primary";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "root";
          type = "partition";
          start = "512MiB";
          end = "100%";
          part-type = "primary";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  });
}
