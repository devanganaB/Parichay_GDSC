import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { provideFirebaseApp, getApp, initializeApp } from '@angular/fire/app';
import { getFirestore, provideFirestore } from '@angular/fire/firestore';
import { AppComponent } from './app.component';
import { PlaceadminService } from './placeadmin.service';
import { RouterModule } from '@angular/router';
import { PlaceadminModule } from './placeadmin/placeadmin.module';
import { SharedModule } from './shared/shared.module';
import { AppRoutingModule } from './app-routing.module';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AngularFireModule } from '@angular/fire/compat';


const firebaseConfig = {
   apiKey: "AIzaSyDDxPqd0elt99twtMADykPMSh7_B21k4G8",
  authDomain: "parichay-flutter.firebaseapp.com",
  projectId: "parichay-flutter",
  storageBucket: "parichay-flutter.appspot.com",
  messagingSenderId: "249516350954",
  appId: "1:249516350954:web:5fd9805864101595ffe693"
};
@NgModule({
  declarations: [AppComponent],
  imports: [
    AppRoutingModule,
    BrowserModule,
    RouterModule,
    PlaceadminModule,
    SharedModule,
    provideFirebaseApp(() => initializeApp(firebaseConfig)),
    provideFirestore(() => getFirestore()),
    AngularFireModule.initializeApp(firebaseConfig),
    NgbModule
  ],
  providers: [PlaceadminService],
  bootstrap: [AppComponent],
})
export class AppModule {}
