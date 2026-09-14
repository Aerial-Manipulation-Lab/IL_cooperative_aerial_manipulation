"""Isolate where Isaac stalls in this container.

Bypasses AppLauncher entirely and drives SimulationApp directly with an explicit,
absolute experience file. If this works, AppLauncher's experience resolution is the
problem. If it still stalls, the problem is Kit itself in this container.

Run:
  isaaclab.sh -p run/minimal_app_test.py
"""
import os
import sys
import time

print("=== PY STARTED ===", flush=True)
print(f"=== EXP_PATH = {os.environ.get('EXP_PATH')}", flush=True)

EXP = "/workspace/isaaclab/apps/isaaclab.python.headless.kit"
print(f"=== experience exists: {os.path.isfile(EXP)}  ({EXP})", flush=True)
print(f"=== user: uid={os.getuid()} name={os.environ.get('USER')!r} HOME={os.environ.get('HOME')!r}", flush=True)
try:
    import pwd
    print(f"=== pwd lookup: {pwd.getpwuid(os.getuid()).pw_name!r}", flush=True)
except Exception as e:
    print(f"=== pwd lookup FAILED: {e!r}", flush=True)

print("=== importing SimulationApp ===", flush=True)
from isaacsim import SimulationApp

print("=== constructing SimulationApp (explicit headless experience) ===", flush=True)
t0 = time.time()
app = SimulationApp({"headless": True}, experience=EXP)
print(f"=== APP UP after {time.time() - t0:.1f}s ===", flush=True)

for i in range(5):
    app.update()
    print(f"=== update {i} ok ===", flush=True)

print("=== closing ===", flush=True)
app.close()
print("=== DONE ===", flush=True)
