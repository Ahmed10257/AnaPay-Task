import { Routes } from '@angular/router';
import { UidCheckComponent } from './Components/uid-check/uid-check';
import { CLIInterfaceComponent } from './Components/cli-interface/cli-interface';

export const routes: Routes = [
  {
    path: 'gui',
    component: UidCheckComponent
  },
  {
    path: 'cli',
    component: CLIInterfaceComponent
  },
  {
    path: '',
    redirectTo: 'gui',
    pathMatch: 'full'
  }
];
