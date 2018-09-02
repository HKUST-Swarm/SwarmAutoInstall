#!/usr/bin/env python
from __future__ import print_function
from jinja2 import Template

if __name__ == "__main__":
    template_str = open("../SwarmConfig/dji_stereo/dji_stereo_template.yaml").read()
    template = Template(template_str)

    extrinsic_str = open("../output/extrinsic_parameter.csv").readlines()
    extrinsic_str = extrinsic_str[2:]
    extrinsic_str = "".join(extrinsic_str)
    
    print(extrinsic_str)
    
    res = template.render(extrinsic_param=extrinsic_str)
    #print(res)    
    open("../SwarmConfig/dji_stereo/dji_stereo.yaml", "w").write(res)
    
    print("Copied extrinsic to dji_stereo.yaml!!!")
